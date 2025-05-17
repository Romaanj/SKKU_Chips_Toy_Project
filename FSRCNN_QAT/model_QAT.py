import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.quantization as tq

class SymmetricQuantizer(torch.autograd.Function):
    @staticmethod
    def forward(ctx, w, scale, num_bits):
        # w is the full-precision weight,
        # scale is either fixed or computed outside
        qmax = 2**(num_bits-1) - 1
        qmin = -qmax
        # quantize
        w_div = w / scale
        w_clamped = torch.clamp(w_div, qmin, qmax)
        w_q = torch.round(w_clamped) * scale
        ctx.scale = scale
        return w_q

    @staticmethod
    def backward(ctx, grad_output):
        # Straight-Through Estimator
        return grad_output, None, None  # grad for w, scale (None), num_bits (None)

class QuantConv2d(nn.Module):
    def __init__(self, *args, num_bits=8, fixed_scale=None, **kwargs):
        super().__init__()
        self.conv      = nn.Conv2d(*args, **kwargs)
        self.num_bits  = num_bits
        # register a float buffer—even though fixed_scale won't train,
        # buffers are saved & loaded with state_dict
        if fixed_scale is not None:
            self.register_buffer('fixed_scale', torch.tensor(fixed_scale))
        else:
            # use negative to mean “no override”
            self.register_buffer('fixed_scale', torch.tensor(-1.0))

    def forward(self, x):
        w = self.conv.weight
        if self.fixed_scale.item() > 0:
            scale = self.fixed_scale
        else:
            qmax = 2**(self.num_bits-1) - 1
            max_val = w.abs().max()
            scale = max_val / qmax if max_val != 0 else torch.tensor(1., device=w.device)
        w_q = SymmetricQuantizer.apply(w, scale, self.num_bits)
        if self.conv.bias is not None:
            b = self.conv.bias
            b_scale = scale
            b_q = SymmetricQuantizer.apply(b, b_scale, self.num_bits)
        else:
            b_q = None

        return F.conv2d(x, w_q, b_q, stride=self.conv.stride, padding=self.conv.padding)


class QuantPReLU(nn.Module):
    def __init__(self, num_parameters=1, init=0.25, num_bits=8, fixed_alpha_scale=None):
        super().__init__()
        self.alpha = nn.Parameter(torch.full((num_parameters,), init))
        self.num_bits = num_bits
        if fixed_alpha_scale is not None:
            self.register_buffer('fixed_alpha_scale', torch.tensor(fixed_alpha_scale))
        else:
            self.register_buffer('fixed_alpha_scale', torch.tensor(-1.0))

    def forward(self, x):
        if self.fixed_alpha_scale.item() > 0:
            scale = self.fixed_alpha_scale
        else:
            qmax = 2**(self.num_bits-1) - 1
            max_val = self.alpha.abs().max()
            scale = max_val / qmax if max_val != 0 else torch.tensor(1., device=self.alpha.device)
        alpha_q = SymmetricQuantizer.apply(self.alpha, scale, self.num_bits)
        return F.prelu(x, alpha_q)

class ZeroInsert(nn.Module):
  def __init__(self, scale):
    super(ZeroInsert, self).__init__()
    self.scale = scale

  def forward(self, x):
    N,C,H,W = x.size()
    out = x.new_zeros(N, C, H*self.scale, W*self.scale)
    # zero insertion
    out[:,:,::self.scale, ::self.scale] = x
    return out

class FSRCNN_QAT(nn.Module):
  def __init__(self, scale_factor = 3, num_channels=3, d=56, s=12, m=4):
    super(FSRCNN_QAT, self).__init__()

    # Conv(3,d,1)
    self.conv_first = nn.Sequential(
        QuantConv2d(num_channels, d, kernel_size=5, padding=5//2),
        QuantPReLU(num_parameters=d, init=0.25)
    )
    # Conv(1,s,d)
    self.conv_shrink = nn.Sequential(
        QuantConv2d(d, s, kernel_size=1),
        QuantPReLU(num_parameters=s, init=0.25)
    )
    # Conv(3,s,s) * m
    self.conv_mapping = nn.Sequential(
        *[QuantConv2d(s,s,kernel_size=3, padding=3//2) for _ in range(m)],
        QuantPReLU(num_parameters=s, init=0.25)
    )
    # Conv(1,d,s)
    self.conv_expanding = nn.Sequential(
        QuantConv2d(s,d,kernel_size=1),
        QuantPReLU(num_parameters=d, init=0.25)
    )

    self.upsample = ZeroInsert(scale_factor)

    # Conv(d,3,9)
    self.conv_last = QuantConv2d(d, num_channels, kernel_size=9, padding=9//2)

    self._initialize_weights()

  def _initialize_weights(self):
    for m in self.modules():
      if isinstance(m, nn.Conv2d):
        nn.init.kaiming_normal_(m.weight, mode='fan_in', nonlinearity='relu')
        if m.bias is not None:
          nn.init.zeros_(m.bias)

  def forward(self, x):
    x = self.conv_first(x)
    x = self.conv_shrink(x)
    x = self.conv_mapping(x)
    x = self.conv_expanding(x)
    x = self.upsample(x)
    x = self.conv_last(x)
    return x

def freeze_to_int8(model):
    qmax = 127
    for module in model.modules():
        # --- Conv2d case --------------------------------------------------
        if isinstance(module, QuantConv2d):
            w = module.conv.weight.data  # float32

            # 1) pick scale: fixed_scale if set, else dynamic
            if getattr(module, 'fixed_scale', None) is not None:
                scale = float(module.fixed_scale)
            else:
                max_val = w.abs().max()
                scale = float(max_val / qmax) if max_val != 0 else 1.0

            # 2) quantize weight
            w_int = torch.clamp(torch.round(w / scale), -qmax, qmax).to(torch.int8)

            # 3) quantize bias if present
            if module.conv.bias is not None:
                b = module.conv.bias.data
                b_int = torch.clamp(torch.round(b / scale), -qmax, qmax).to(torch.int8)
            else:
                b_int = None

            # 4) stash buffers
            module.register_buffer('weight_int',   w_int)
            module.register_buffer('bias_int',     b_int)
            module.register_buffer('weight_scale', torch.tensor(scale))

        # --- PReLU case ---------------------------------------------------
        elif isinstance(module, QuantPReLU):
            alpha = module.alpha.data  # float32

            # 1) pick alpha-scale: fixed_alpha_scale if set, else dynamic
            if getattr(module, 'fixed_alpha_scale', None) is not None:
                scale = float(module.fixed_alpha_scale)
            else:
                max_val = alpha.abs().max()
                scale = float(max_val / qmax) if max_val != 0 else 1.0

            # 2) quantize alpha
            alpha_int = torch.clamp(torch.round(alpha / scale), -qmax, qmax).to(torch.int8)

            # 3) stash buffers
            module.register_buffer('alpha_int',   alpha_int)
            module.register_buffer('alpha_scale', torch.tensor(scale))

class Int8Conv2d(nn.Module):
    def __init__(self, quant_module: QuantConv2d):
        super().__init__()
        # freeze_to_int8 에서 붙여둔 buffer 를 가져다 쓴다
        self.w_int = quant_module.weight_int
        self.b_int = quant_module.bias_int
        self.scale = float(quant_module.weight_scale)  # Python float
        # conv parameter 복사 (stride, padding 등)
        cfg = quant_module.conv
        self.stride, self.padding = cfg.stride, cfg.padding

    def forward(self, x):
        # 1) 정수형 conv 연산 (실제로는 int8×int8→int32)
        #    PyTorch에선 직접 지원 안 되므로 float로 흉내:
        y_int = F.conv2d(x, self.w_int.float(), self.b_int.float() if self.b_int is not None else None,
                         stride=self.stride, padding=self.padding)
        # 2) scale 을 곱해주면 float32 결과
        return y_int * self.scale

class Int8PReLU(nn.Module):
    def __init__(self, quant_module: QuantPReLU):
      super().__init__()
      self.alpha_int = quant_module.alpha_int
      self.scale_alpha = float(quant_module.alpha_scale)

    def forward(self, x):
      # 1) 진짜 slope 복원
      alpha_real = self.alpha_int.float() * self.scale_alpha
      # 2) PReLU 에 바로 넘기고, 추가 스케일링 금지!
      return F.prelu(x, alpha_real)

class FSRCNN_Int8(nn.Module):
    def __init__(self,
                 conv_first: nn.Module,
                 conv_shrink: nn.Module,
                 conv_mapping: nn.Module,
                 conv_expanding: nn.Module,
                 upsample: nn.Module,
                 conv_last: nn.Module):
        """
        build_int8_model() 에서 넘겨 받은 Int8Conv2d 모듈들로 초기화
        """
        super().__init__()
        self.conv_first    = conv_first
        self.conv_shrink   = conv_shrink
        self.conv_mapping  = conv_mapping
        self.conv_expanding= conv_expanding
        self.upsample      = upsample
        self.conv_last     = conv_last

    def forward(self, x):
        x = self.conv_first(x)
        x = self.conv_shrink(x)
        x = self.conv_mapping(x)
        x = self.conv_expanding(x)
        x = self.upsample(x)
        x = self.conv_last(x)
        return x

def build_int8_model(qat_model):
    # 1) 먼저 weight_int, alpha_int 버퍼들 달기
    freeze_to_int8(qat_model)

    # 2) QuantConv2d → Int8Conv2d, QuantPReLU → Int8PReLU
    int8_layers = {}
    for name, module in qat_model.named_children():
        if isinstance(module, QuantConv2d):
            int8_layers[name] = Int8Conv2d(module)
        elif isinstance(module, QuantPReLU):
            int8_layers[name] = Int8PReLU(module)
        elif isinstance(module, nn.Sequential):
            # Sequential 안쪽도 같은 방식으로 교체
            new_seq = []
            for sub in module:
                if isinstance(sub, QuantConv2d):
                    new_seq.append(Int8Conv2d(sub))
                elif isinstance(sub, QuantPReLU):
                    new_seq.append(Int8PReLU(sub))
                else:
                    new_seq.append(sub)
            int8_layers[name] = nn.Sequential(*new_seq)
        else:
            int8_layers[name] = module

    # 3) FSRCNN_Int8 에 넣어서 반환
    return FSRCNN_Int8(
        conv_first     = int8_layers['conv_first'],
        conv_shrink    = int8_layers['conv_shrink'],
        conv_mapping   = int8_layers['conv_mapping'],
        conv_expanding = int8_layers['conv_expanding'],
        upsample       = int8_layers['upsample'],
        conv_last      = int8_layers['conv_last'],
    )
