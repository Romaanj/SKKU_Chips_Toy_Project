import os
import sys
import math
import numpy as np
import torch
import torchvision.transforms as transforms
from PIL import Image
from pathlib import Path

sys.path.append(r'C:\Users\송성민\Desktop\SKKU_CHIPS\SKKU_Chips_Toy_Project\FSRCNN_QAT')
from model_QAT import *

# ------------------------------------------------------------------------------------------------------------------------

def Read_Image_Return_Unsqueezed_Tensor(image_path: str):
    img = Image.open(image_path).convert("RGB")
    tensor_img = transforms.ToTensor()(img)
    unsqueezed_tensor = tensor_img.unsqueeze(0)
    return unsqueezed_tensor

def Quantize_Img_Tensor(normalized_img_tensor: torch.Tensor, fraction_bits):
    """
    Description:
    (1) Assumes default Q-format = Q1.f, but integer size doesn't matter from 1 to (32-f)
    (2) Requires PIL.Image.Convert style normalization

    Arguments:
    (1) normalized_img_tensor: PIL.Image converted with 'RGB', transformed to torch.Tensor, and unsqueezed: (1, 3, H, W)
    (2) fraction_bits        : Ex: 15 -> Q1.15
    """
    scale = 2 ** fraction_bits
    return torch.round(normalized_img_tensor * scale) / scale

def Read_LR_Image_Return_Quantized_Input_Tensor(lr_image_path: str, lr_quantize_fraction_bits):
    lr_image_tensor = Read_Image_Return_Unsqueezed_Tensor(lr_image_path)
    return Quantize_Img_Tensor(lr_image_tensor, lr_quantize_fraction_bits)

# ------------------------------------------------------------------------------------------------------------------------

def Quantize_and_Save_Tensor(tensor: torch.Tensor, layer_name: str, save_dir="result"):

    B, C, H, W = tensor.shape
    tensor = tensor.squeeze(0).cpu()  # [C, H, W]

    layer_dir = Path(save_dir) / layer_name
    layer_dir.mkdir(parents=True, exist_ok=True)

    for c in range(C):
        channel = tensor[c]

        # From float32 to int32 (Q4.15)
        q_vals = (channel * (1 << 15)).round().clamp(-2**18, 2**18 - 1).int()

        # 19bit 2's complement → 5-digit hex
        hex_lines = [f"{(val & 0xFFFFF):05X}" for val in q_vals.view(-1)]

        with open(layer_dir / f"{layer_name}_output_{c}.txt", "w") as f:
            f.write("\n".join(hex_lines))

def SuperResolution(checkpoint_path: str, lr_tensor: torch.Tensor, device='cpu'):
    int8_model = torch.load(checkpoint_path, map_location=device, weights_only=False)
    int8_model.eval()
    print(int8_model)

    out1 = int8_model.conv_first(lr_tensor)
    print("conv_first:", out1.shape, out1.min().item(), out1.max().item())
    Quantize_and_Save_Tensor(out1, "conv_first")

    # 2) conv_shrink
    out2 = int8_model.conv_shrink(out1)
    print("conv_shrink:", out2.shape, out2.min().item(), out2.max().item())
    Quantize_and_Save_Tensor(out2, "conv_shrink")

    # 3) conv_mapping
    out = out2
    for i, layer in enumerate(int8_model.conv_mapping):
        out = layer(out)
        print(f"conv_mapping[{i}]:", out.shape, out.min().item(), out.max().item())
        Quantize_and_Save_Tensor(out, f"conv_mapping.{i}")

    # 4) conv_expanding
    out3 = int8_model.conv_expanding(out)
    print("conv_expanding:", out3.shape, out3.min().item(), out3.max().item())
    Quantize_and_Save_Tensor(out3, "conv_expanding")

    # 5) upsample (ZeroInsert)
    out4 = int8_model.upsample(out3)
    print("upsample:", out4.shape, out4.min().item(), out4.max().item())
    Quantize_and_Save_Tensor(out4, "upsample")

    # 6) conv_last
    out5 = int8_model.conv_last(out4)
    print("conv_last:", out5.shape, out5.min().item(), out5.max().item())
    Quantize_and_Save_Tensor(out5, "conv_last")

    return out5

# ------------------------------------------------------------------------------------------------------------------------

def Crop_Tensor_for_Calc_PSNR(upscale_factor, h_lr, w_lr, sr, hr):
    H = h_lr * upscale_factor
    W = w_lr * upscale_factor
    return sr[:, :, :H, :W], hr[:, :, :H, :W]

def Calc_PSNR(LR, SR, HR, upscale_factor=3, max_val=1.0):

    sr, hr = Crop_Tensor_for_Calc_PSNR(upscale_factor, LR.size(2), LR.size(3), SR, HR)

    mse = torch.mean((hr - sr) ** 2).item()
    if mse == 0:
        return float('inf')
    return 10 * math.log10((max_val ** 2) / mse)

# ------------------------------------------------------------------------------------------------------------------------

if __name__ == '__main__':
    LR_path = r'C:\Users\송성민\Desktop\SKKU_CHIPS\Set5\LRbicx3\butterfly.png'
    LR = Read_LR_Image_Return_Quantized_Input_Tensor(LR_path, 7)

    checkpoint_path = r"C:\Users\송성민\Desktop\SKKU_CHIPS\checkpoints_QAT\checkpoint_epoch_50_1.pth"
    SR = SuperResolution(checkpoint_path, LR)

    HR_path = r'C:\Users\송성민\Desktop\SKKU_CHIPS\Set5\original\butterfly.png'
    HR = Read_Image_Return_Unsqueezed_Tensor(HR_path)

    psnr = Calc_PSNR(LR, SR, HR)
    print(f"PSNR = {psnr:.2f} dB")
