from PIL import Image
import numpy as np
import serial
import torchvision.transforms as transforms
import torch
import time
import struct
import pandas as pd
import os

def quantize_tensor_to_int(tensor, fraction):   
    scale = 2 ** fraction
    return torch.round(tensor * scale).to(torch.uint8)

def generate_coe(image_path, weight_files, conv_last_files, q_fraction=8):
    img = Image.open(image_path).convert("RGB")
    tensor_img = transforms.ToTensor()(img)
    fixed_point = quantize_tensor_to_int(tensor_img, q_fraction)

    fixed_point = fixed_point.permute(1, 2, 0)             # (H, W, 3)
    pixels = fixed_point.reshape(-1, 3).tolist()

    all_weight_files = weight_files + conv_last_files
    all_weights = []  # int8 값들이 모두 들어갈 리스트
    for filepath in all_weight_files:
        if not os.path.exists(filepath):
            print(f"[경고] 파일이 존재하지 않음: {filepath}")
            continue
            
        print(f"로딩 중: {filepath} ...", end='')
        df = pd.read_csv(filepath, header=None)         # CSV를 DataFrame으로 읽기
        weights = df.values.astype(np.int32)             # int8 배열로 변환
        weights_flat = weights.flatten().tolist()        # 1D list로 펼치기
        all_weights.extend(weights_flat)
        print(f" 완료 (개수: {len(weights_flat)})")
        
    print(f"총 수집된 weight 개수 (int8): {len(all_weights)}")

    padding_needed = (4 - (len(all_weights) % 4)) % 4
    if padding_needed > 0:
        all_weights.extend([0] * padding_needed)
        print(f"패딩 추가: {padding_needed}개 (0으로 채움)")

    weight_groups = np.array(all_weights, dtype=np.int32).reshape(-1, 4)
    total_weight_groups = weight_groups.shape[0]
    print(f"4바이트 그룹으로 변환 완료, 총 그룹 수: {total_weight_groups}")

    print(weight_groups)

    with open('fetcher.coe', 'w') as coe:
        coe.write("memory_initialization_radix=16;\n")
        coe.write("memory_initialization_vector=\n")
        for i, (r, g, b) in enumerate(pixels):
            coe.write(f"{r:02X}{g:02X}{b:02X}00,\n")
        for i, weight_group in enumerate(weight_groups):
            w0, w1, w2, w3 = weight_group
            if ((w0, w1, w2, w3) == weight_groups[-1]).all():
                coe.write(f"{w0 & 0xFF:02X}{w1 & 0xFF:02X}{w2 & 0xFF:02X}{w3 & 0xFF:02X};")
            else:
                coe.write(f"{w0 & 0xFF:02X}{w1 & 0xFF:02X}{w2 & 0xFF:02X}{w3 & 0xFF:02X},\n")

# --------------------------
# 사용 예시
# --------------------------
if __name__ == "__main__":
    image_path = '../../SET5/LRbicx3/butterfly.png'
    
    weight_files = [
        '../../int8_params_scale_fixed_retraining/conv_first.0_weight.csv',
        '../../int8_params_scale_fixed_retraining/conv_first.0_bias.csv',
        '../../int8_params_scale_fixed_retraining/conv_first.1_alpha.csv',
        '../../int8_params_scale_fixed_retraining/conv_shrink.0_weight.csv',
        '../../int8_params_scale_fixed_retraining/conv_shrink.0_bias.csv',
        '../../int8_params_scale_fixed_retraining/conv_shrink.1_alpha.csv',
        '../../int8_params_scale_fixed_retraining/conv_mapping.0_weight.csv',
        '../../int8_params_scale_fixed_retraining/conv_mapping.0_bias.csv',
        '../../int8_params_scale_fixed_retraining/conv_mapping.1_weight.csv',
        '../../int8_params_scale_fixed_retraining/conv_mapping.1_bias.csv',
        '../../int8_params_scale_fixed_retraining/conv_mapping.2_weight.csv',
        '../../int8_params_scale_fixed_retraining/conv_mapping.2_bias.csv',
        '../../int8_params_scale_fixed_retraining/conv_mapping.3_weight.csv',
        '../../int8_params_scale_fixed_retraining/conv_mapping.3_bias.csv',
        '../../int8_params_scale_fixed_retraining/conv_mapping.4_alpha.csv',
        '../../int8_params_scale_fixed_retraining/conv_expanding.0_weight.csv',
        '../../int8_params_scale_fixed_retraining/conv_expanding.0_bias.csv',
        '../../int8_params_scale_fixed_retraining/conv_expanding.1_alpha.csv',
    ]

    conv_last_files = [
        '../../int8_params_scale_fixed_retraining/conv_last_weight.csv',
        '../../int8_params_scale_fixed_retraining/conv_last_bias.csv'
    ]
    
    # 존재하는 파일만 필터링
    existing_weights      = [f for f in weight_files if os.path.exists(f)]
    existing_conv_last    = [f for f in conv_last_files if os.path.exists(f)]
    
    if os.path.exists(image_path) and (existing_weights or existing_conv_last):
        generate_coe(image_path, existing_weights, existing_conv_last)
        #transfer_image_and_weights(image_path, existing_weights, existing_conv_last)
    else:
        print("필요한 파일(이미지/CSV)이 누락되었습니다. 경로를 확인하세요.")
