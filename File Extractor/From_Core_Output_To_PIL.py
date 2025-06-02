import sys
import math
import torch
from torchvision import transforms
from PIL import Image

def to_float(hexval):
    val = int(hexval, 16)
    if val & (1 << 19):
        val -= 1 << 19
    return val / (1 << 15)

def read_hex_file(filepath, height=252, width=252):
    with open(filepath, 'r') as f:
        lines = f.readlines()
    if len(lines) != height * width:
        raise ValueError(f"Expected {height * width} values, got {len(lines)} in {filepath}")
    
    floats = [to_float(line.strip()) for line in lines]
    floats = torch.clamp(torch.tensor(floats), min=0.0, max=1.0)
    tensor = torch.tensor(floats, dtype=torch.float32).reshape(height, width)
    return tensor

def Calc_PSNR_2(SR, HR_filepath, max_val=1.0):

    HR = transforms.ToTensor()(Image.open(HR_filepath).convert('RGB'))
    HR = HR[:, :252, :252]

    #HR = HR[0]

    mse = torch.mean((HR - SR) ** 2).item()
    #print(torch.mean((HR[0] - SR[0])))
    #print(torch.mean((HR[1] - SR[1])))
    #print(torch.mean((HR[2] - SR[2])))
    if mse == 0:
        return float('inf')
    return 10 * math.log10((max_val ** 2) / mse)

#-----------------------------------------------------------------------------------------

sys.path.append(r'C:\Users\송성민\Desktop\SKKU_CHIPS\SKKU_Chips_Toy_Project\File_Extractor')
from Output_Extractor_From_QAT_Model import *

# File paths
filepaths = ['core_output_0.txt', 'core_output_1.txt', 'core_output_2.txt']

# Read and stack into a (3, 252, 252) tensor
channels = [read_hex_file(fp) for fp in filepaths]
tensor = torch.stack(channels)

LR_path = r'C:\Users\송성민\Desktop\SKKU_CHIPS\Set5\LRbicx3\butterfly.png'
LR = Read_LR_Image_Return_Quantized_Input_Tensor(LR_path, 7)

checkpoint_path = r"C:\Users\송성민\Desktop\SKKU_CHIPS\checkpoints_QAT\checkpoint_epoch_50_1.pth"
SR = SuperResolution(checkpoint_path, LR)

#for i in range(SR.shape[2]):
#    for j in range(SR.shape[3]):
#        if (tensor[2][i][j] < 0) or (tensor[2][i][j] > 1):
#            print(tensor[2][i][j], SR[0][2][i][j])

HR_path = r'C:\Users\송성민\Desktop\SKKU_CHIPS\Set5\original\butterfly.png'
psnr = Calc_PSNR_2(tensor, HR_path)
print(f"PSNR = {psnr:.2f} dB")

# Convert to PIL image
to_pil = transforms.ToPILImage()
image = to_pil(tensor)

#sr_image = to_pil(SR[0])

#image.show()

#sr_image.save('sr.png')
image.save('output.png')
