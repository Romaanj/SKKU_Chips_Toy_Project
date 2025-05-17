import numpy as np
import torch
import torch.nn as nn
from PIL import Image
import torchvision.transforms as transforms
import os
import sys

sys.path.append(r'C:\Users\송성민\Desktop\SKKU_CHIPS\SKKU_Chips_Toy_Project\FSRCNN')
from model import FSRCNN

# 모델 인스턴스 생성 (예: FSRCNN, 학습 시 사용한 scale_factor와 동일하게)
model = FSRCNN(scale_factor=3, d=56, s=12, m=4)
model.eval()

# 학습된 체크포인트 불러오기 (원하는 checkpoint 파일 경로로 수정)
checkpoint_path = r'C:/Users/송성민/Desktop/SKKU_CHIPS/checkpoints/x3_fine_tuned/checkpoint_epoch_20.pth'
checkpoint = torch.load(checkpoint_path, map_location='cpu')
model.load_state_dict(checkpoint['model_state_dict'])

# 이미지 전처리 정의: PIL Image → Tensor
to_tensor = transforms.ToTensor()

# 테스트용 LR 이미지 로드 (예시)
lr_image_name = '/butterfly.png'
lr_image_path = r'C:/Users/송성민/Desktop/SKKU_CHIPS/Set5/LRbicx3'

# ===== 고정소수점 변환 =====
def float_to_fixed_hex (val, Q_INT, Q_FRAC):
    fixed_val = int(round(val * (1 << Q_FRAC)))
    if fixed_val < 0:
        fixed_val = (1 << (Q_INT + Q_FRAC)) + fixed_val
    if Q_INT + Q_FRAC == 16:
        return f"{fixed_val:04X}"
    elif 28 < Q_INT + Q_FRAC and Q_INT + Q_FRAC <= 32:
        return f"{fixed_val:08X}"

# ===== 인풋 아웃풋 추출 =====

def extract_input_output(lr_image_path, lr_image_name, Q_INT, Q_FRAC):
    lr_image = Image.open(lr_image_path +  lr_image_name).convert('RGB')
    lr_tensor = to_tensor(lr_image).unsqueeze(0)

    target_dir = f'./result/{lr_image_name}/'
    os.makedirs(target_dir, exist_ok=True)

    target_output = model.conv_first[0](lr_tensor).detach().numpy()

    for in_channel_idx in range(lr_tensor.shape[1]):
        with open(f"{target_dir}/input_{in_channel_idx}.txt", "w") as fp:
            for row in range(lr_tensor.shape[2]):
                for col in range(lr_tensor.shape[3]):
                    val = float_to_fixed_hex(lr_tensor[0][in_channel_idx][row][col].item(), Q_INT, Q_FRAC)
                    fp.write(f"{val}" + "\n")

    for out_channel_idx in range(target_output.shape[1]):
        with open(f"{target_dir}/output_{out_channel_idx}.txt", "w") as fp:
            for row in range(target_output.shape[2]):
                for col in range(target_output.shape[3]):
                    val = float_to_fixed_hex(target_output[0][out_channel_idx][row][col].item(), Q_INT, Q_FRAC)
                    fp.write(f"{val}" + "\n")

# ========================================

def reproduce_ConvTranspose2d_and_verify(lr_image_path, lr_image_name, model):

    def upsample_and_to_tensor(input_tensor, scale_factor):
        # input_tensor.shape = (N, C, H, W)
        # result.shape = (N, C, H * scale, W * scale)
        # upsampling by inserting zero

        result = np.zeros((input_tensor.shape[0], input_tensor.shape[1], input_tensor.shape[2] * scale_factor, input_tensor.shape[3] * scale_factor), dtype=np.float32)

        for batch in range(result.shape[0]):
            for channel in range(result.shape[1]):
                for row in range(0, result.shape[2], scale_factor):
                    for col in range(0, result.shape[3], scale_factor):
                        original_row, original_col = row // scale_factor, col // scale_factor
                        result[batch][channel][row][col] = input_tensor[batch][channel][original_row][original_col]

        result = torch.from_numpy(result)
        return result

    def generate_transpose_convolution_input(model, input_tensor):
        # input model should have a layer named 'conv_first', 'conv_shrink', 'conv_mapping', 'conv_expanding'
        # input model should be trained and in evaluation mode

        result = model.conv_first(input_tensor)
        result = model.conv_shrink(result)
        result = model.conv_mapping(result)
        result = model.conv_expanding(result)
        return result

    def pseudo_transpose_convolution(model, input_tensor):
        # input model should have a layer named 'deconv'
        # stride of deconv layer should be a tuple of the same integer
        # input model should be trained and in evaluation mode
        # than, this function returns its equivalent nn.Conv2d class
        # maybe, numerically best?

        conv2d = nn.Conv2d(
            in_channels = model.deconv.in_channels,
            out_channels = model.deconv.out_channels,
            kernel_size = model.deconv.kernel_size,
            padding = model.deconv.padding)

        conv2d.weight.data = model.deconv.weight.data.permute(1, 0, 2, 3).flip(-1, -2).clone()
        conv2d.bias.data = model.deconv.bias.data.clone()

        input_tensor = generate_transpose_convolution_input(model, input_tensor)
        input_tensor = upsample_and_to_tensor(input_tensor, model.deconv.stride[0])

        result = conv2d(input_tensor)
        return result

    lr_image = Image.open(lr_image_path +  lr_image_name).convert('RGB')
    lr_tensor = to_tensor(lr_image).unsqueeze(0)

    golden = model(lr_tensor)
    result = pseudo_transpose_convolution(model, lr_tensor)

    max_error = 0.0
    sum_error = 0.0
    
    batch_at_max, channel_at_max, row_at_max, col_at_max, golden_at_max, result_at_max = 0, 0, 0, 0, 0, 0
    for batch in range(golden.shape[0]):
        for channel in range(golden.shape[1]):
            for row in range(golden.shape[2]):
                for col in range(golden.shape[3]):
                    abs_error = abs((golden[0][channel][row][col].item() - result[0][channel][row][col].item()) / golden[0][channel][row][col].item())
                    sum_error += abs_error
                    if max_error < abs_error:
                        max_error, batch_at_max, channel_at_max, row_at_max, col_at_max, golden_at_max, result_at_max = abs_error, batch, channel, row, col, golden[0][channel][row][col].item(), result[0][channel][row][col].item()

    mean_error = sum_error / (golden.shape[1] * golden.shape[2] * golden.shape[3])

    return (max_error, mean_error, batch_at_max, channel_at_max, row_at_max, col_at_max, golden_at_max, result_at_max)

# ===== conv2d의 특정 픽셀 결괏값 예상 =====
def conv2d_one_pixel(target_channel, target_row, target_col, input_tensor, weight_arr, bias_arr):

    input_pixels = np.array([])
    input_weight = np.array([])

    for channel in range(lr_tensor.shape[1]):
        for row in range(target_row - 2, target_row + 3):
            for col in range(target_col - 2, target_col + 3):
                if row < 0 or col < 0:
                    input_pixels = np.append(input_pixels, [0])
                elif row >= lr_tensor.shape[2] or col >= lr_tensor.shape[3]:
                    input_pixels = np.append(input_pixels, [0])
                else:
                    input_pixels = np.append(input_pixels, input_tensor[0][channel][row][col])

    for channel in range(weight_arr.shape[1]):
        input_weight = np.append(input_weight, weight_arr[target_channel][channel].flatten())

    input_bias = bias_arr[target_channel]

    result = np.sum(np.multiply(input_pixels, input_weight)) + input_bias

    temp = np.multiply(input_pixels, input_weight)
    for item in temp:
        print(float_to_fixed_hex(item, 3, 28))
    print(float_to_fixed_hex(input_bias, 3, 28))

    return np.sum(np.multiply(input_pixels, input_weight)) + input_bias

# ===== estimation of conv2d in conv_first =====

#conv_first_weights = model.conv_first[0].weight.data.numpy()
#conv_first_biases = model.conv_first[0].bias.data.numpy()

def estimate_conv_first_conv2d(input_tensor, weight_arr, bias_arr):
    
    max_error = -1
    conv_first_conv2d_output = model.conv_first[0](lr_tensor).detach().numpy()
    
    for channel in range(conv_first_conv2d_output.shape[1]):
        for row in range(conv_first_conv2d_output.shape[2]):
            for col in range(conv_first_conv2d_output.shape[3]):
                temp = conv2d_one_pixel(channel, row, col, input_tensor, weight_arr, bias_arr)
                original = conv_first_conv2d_output[0][channel][row][col]
                error = abs(original - temp) / original * 100
                if max_error < error:
                    max_error = error

    print(f"{channel}: {max_error}")

if __name__ == '__main__':
    lr_image = Image.open(lr_image_path +  lr_image_name).convert('RGB')
    lr_tensor = to_tensor(lr_image).unsqueeze(0)
    weight_arr = model.conv_first[0].weight.data.numpy()
    bias_arr = model.conv_first[0].bias.data.numpy()
    print((4503) // 84, (4503) % 84)
    result = conv2d_one_pixel(12, (4503) // 84, (4503) % 84, lr_tensor, weight_arr, bias_arr)
    print(result)
    print(float_to_fixed_hex(result, 2, 14))
    #result = reproduce_ConvTranspose2d_and_verify(lr_image_path, lr_image_name, model)
    #print(result)
