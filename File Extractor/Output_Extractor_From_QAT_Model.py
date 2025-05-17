import os
import sys
import math
import numpy as np
import torch
import torchvision.transforms as transforms
from PIL import Image
from pathlib import Path

def quantize_tensor(x, fractional_bits):
    """
    x: 정규화된 이미지 텐서 
    fractional_bits: 소수부 비트 수 (예: 15) -> Q1.15
    """
    scale = 2 ** fractional_bits
    return torch.round(x * scale) / scale

def calculate_psnr(original, quantized, max_val=1.0):
    mse = torch.mean((original - quantized) ** 2).item()
    if mse == 0:
        return float('inf')
    return 10 * math.log10((max_val ** 2) / mse)

def save_tensor_q4_15(tensor: torch.Tensor, layer_name: str, save_dir="result"):

    B, C, H, W = tensor.shape
    tensor = tensor.squeeze(0).cpu()  # [C, H, W]

    layer_dir = Path(save_dir) / layer_name
    layer_dir.mkdir(parents=True, exist_ok=True)

    for c in range(C):
        channel = tensor[c]
        
        # 실수 → Q4.15 정수로 변환
        q_vals = (channel * (1 << 15)).round().clamp(-2**18, 2**18 - 1).int()

        # 19비트 2's complement → 5자리 hex 저장
        hex_lines = [f"{(val & 0x7FFFF):05X}" for val in q_vals.view(-1)]

        with open(layer_dir / f"{layer_name}_output_{c}.txt", "w") as f:
            f.write("\n".join(hex_lines))

sys.path.append(r'C:\Users\송성민\Desktop\SKKU_CHIPS\SKKU_Chips_Toy_Project\FSRCNN_QAT')
from model_QAT import *

int8_model = torch.load(r"C:\Users\송성민\Desktop\SKKU_CHIPS\checkpoints_QAT\checkpoint_epoch_50_1.pth", map_location='cpu', weights_only=False)
int8_model.eval()

print(int8_model)

lr_image_path = r'C:\Users\송성민\Desktop\SKKU_CHIPS\Set5\LRbicx3\butterfly.png'
original_path = r'C:\Users\송성민\Desktop\SKKU_CHIPS\Set5\original\butterfly.png'

lr_img = Image.open(lr_image_path).convert("RGB")
original = Image.open(original_path).convert("RGB")

# 원본: (3, H, W)
tensor_lr_img = transforms.ToTensor()(lr_img)
tensor_original = transforms.ToTensor()(original)

# → (1, 3, H, W)
tensor_lr_img = tensor_lr_img.unsqueeze(0)
tensor_original = tensor_original.unsqueeze(0)

# 0) input
lr_q = quantize_tensor(tensor_lr_img, 7)
x = lr_q

# 1) conv_first
out1 = int8_model.conv_first(x)
print("conv_first:", out1.shape, out1.min().item(), out1.max().item())
save_tensor_q4_15(out1, "conv_first")

# 2) conv_shrink
out2 = int8_model.conv_shrink(out1)
print("conv_shrink:", out2.shape, out2.min().item(), out2.max().item())
save_tensor_q4_15(out2, "conv_shrink")

# 3) conv_mapping 단계별
out = out2
for i, layer in enumerate(int8_model.conv_mapping):
    out = layer(out)
    print(f"conv_mapping[{i}]:", out.shape, out.min().item(), out.max().item())
    save_tensor_q4_15(out, f"conv_mapping.{i}")

# 4) conv_expanding
out3 = int8_model.conv_expanding(out)
print("conv_expanding:", out3.shape, out3.min().item(), out3.max().item())
save_tensor_q4_15(out3, "conv_expanding")

# 5) upsample (ZeroInsert)
out4 = int8_model.upsample(out3)
print("upsample:", out4.shape, out4.min().item(), out4.max().item())
save_tensor_q4_15(out4, "upsample")

# 6) conv_last
out5 = int8_model.conv_last(out4)
print("conv_last:", out5.shape, out5.min().item(), out5.max().item())
save_tensor_q4_15(out5, "conv_last")

upscale = 3
h_sr, w_sr = lr_q.size(2) * upscale, lr_q.size(3) * upscale

sr = out5[:, :, :h_sr, :w_sr]
hr = tensor_original[:, :, :h_sr, :w_sr]

psnr = calculate_psnr(sr, hr)
print(f"PSNR = {psnr:.2f} dB")
