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

def transfer_image_and_weights(image_path, weight_files, conv_last_files, q_fraction=7,
                              port='COM3', baudrate=115200, timeout=1):
    """
    1) 이미지 데이터 전송
    2) (weight_files + conv_last_files)를 합친 뒤, 
       모든 weight를 한 번에 UART로 전송
    3) Readback 확인
    """
    print("=== 이미지 + Weight 연속 전송 시작 ===\n")
    
    # 1) UART 포트 열기
    try:
        ser = serial.Serial(
            port=port,
            baudrate=baudrate,
            bytesize=serial.EIGHTBITS,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            timeout=timeout
        )
        ser.reset_input_buffer()
        time.sleep(0.1)
        print("UART 포트 연결 완료")
    except Exception as e:
        print(f"UART 포트 연결 오류: {e}")
        return
    
    try:
        # ===== STEP 1: 이미지 데이터 전송 =====
        print("\n[Step 1] 이미지 데이터 전송...")
        
        # 이미지 → 텐서 → 고정소수점 변환
        img = Image.open(image_path).convert("RGB")
        tensor_img = transforms.ToTensor()(img)
        fixed_point = quantize_tensor_to_int(tensor_img, q_fraction)
        
        # (H, W, C) 순으로 바꾼 뒤, (num_pixels, 3) 리스트로 변환
        fixed_point = fixed_point.permute(1, 2, 0)             # (H, W, 3)
        pixels = fixed_point.reshape(-1, 3).tolist()           # 리스트 of [r, g, b]
        
        print(f"전송할 픽셀 수: {len(pixels)}")
        
        # sent_pixels.txt에 전송한 픽셀을 기록
        with open('sent_pixels.txt', 'w') as f_pixels:
            for i, (r, g, b) in enumerate(pixels):
                # 4바이트: [R, G, B, 0x00]
                word4 = struct.pack('>BBBB', r, g, b, 0x00)
                ser.write(word4)
                f_pixels.write(f"{r:02X} {g:02X} {b:02X} 00\n")
                
                if (i + 1) % 1000 == 0:
                    print(f"픽셀 전송 진행률: {i+1}/{len(pixels)}")
        
        # 픽셀 완료 ACK 대기 (최대 10초)
        ser.timeout = 10
        try:
            ack = ser.readline().decode(errors='ignore').strip()
            print(f"[FPGA] {ack}")
        except:
            print("픽셀 ACK 수신 타임아웃")
        
        
        # ===== STEP 2: Weight + Conv Last 데이터 한 번에 전송 =====
        print(f"\n[Step 2] Weight + Conv Last 데이터 연속 전송 시작...")
        
        # 2-1) 모든 weight 파일 리스트를 합치기
        all_weight_files = weight_files + conv_last_files
        print(f"▶ 전송할 CSV 파일 총 {len(all_weight_files)}개:")
        for p in all_weight_files:
            print(f"   - {p}")
        
        # 2-2) CSV 파일들에서 모든 weight를 읽어서 하나의 리스트(all_weights)로 모으기
        all_weights = []  # int8 값들이 모두 들어갈 리스트
        for filepath in all_weight_files:
            if not os.path.exists(filepath):
                print(f"[경고] 파일이 존재하지 않음: {filepath}")
                continue
            
            print(f"로딩 중: {filepath} ...", end='')
            df = pd.read_csv(filepath, header=None)         # CSV를 DataFrame으로 읽기
            weights = df.values.astype(np.int8)             # int8 배열로 변환
            weights_flat = weights.flatten().tolist()        # 1D list로 펼치기
            all_weights.extend(weights_flat)
            print(f" 완료 (개수: {len(weights_flat)})")
        
        print(f"총 수집된 weight 개수 (int8): {len(all_weights)}")
        
        # 2-3) 4바이트 단위로 묶기 위해 패딩 필요 여부 계산
        padding_needed = (4 - (len(all_weights) % 4)) % 4
        if padding_needed > 0:
            all_weights.extend([0] * padding_needed)
            print(f"패딩 추가: {padding_needed}개 (0으로 채움)")
        
        # 2-4) numpy 배열로 바꿔서 (N, 4) 모양으로 reshape
        weight_groups = np.array(all_weights, dtype=np.int8).reshape(-1, 4)
        total_weight_groups = weight_groups.shape[0]
        print(f"4바이트 그룹으로 변환 완료, 총 그룹 수: {total_weight_groups}")
        
        # 2-5) 실제 UART 전송 (big-endian signed int8 → 4개 묶음)
        with open('sent_weights.txt', 'w') as f_w:
            f_w.write(f"# Total int8 weights (after padding): {len(all_weights)}\n")
            f_w.write(f"# CSV files: {all_weight_files}\n\n")
            
            for i, weight_group in enumerate(weight_groups):
                w0, w1, w2, w3 = weight_group   # 각각 int8 값
                # 전송: struct.pack('>bbbb')로 signed int8 을 big-endian 4바이트로 묶음
                word4 = struct.pack('>bbbb', w0, w1, w2, w3)
                ser.write(word4)
                
                # 로그 파일에 [w0, w1, w2, w3] 형태로 기록
                f_w.write(f"[{w0:4d}, {w1:4d}, {w2:4d}, {w3:4d}]\n")
                
                if (i + 1) % 500 == 0:
                    print(f"Weight 전송 진행률: {i+1}/{total_weight_groups}")
        
        # 2-6) Weight 전체 전송 후 ACK 대기 (최대 10초)
        ser.timeout = 10
        try:
            ack = ser.readline().decode(errors='ignore').strip()
            print(f"[FPGA] {ack}")
        except:
            print("Weight ACK 수신 타임아웃")
        
        
        # ===== STEP 3: 데이터 검증 (Readback) =====
        print(f"\n[Step 3] 데이터 검증 (Readback) 시작...")
        
        # 3-1) 픽셀 Readback
        print("▶ 픽셀 데이터 Readback 중...")
        ser.timeout = 1
        pixel_readback = []
        for _ in range(len(pixels)):
            buf = ser.read(4)
            if len(buf) < 4:
                break
            pixel_readback.append(buf)
        
        # 픽셀 readback 완료 ACK (옵션)
        try:
            ack = ser.readline().decode(errors='ignore').strip()
            print(f"[FPGA] {ack}")
        except:
            pass
        
        # 3-2) Weight Readback
        print("▶ Weight 데이터 Readback 중...")
        weight_readback = []
        for _ in range(total_weight_groups):
            buf = ser.read(4)
            if len(buf) < 4:
                break
            weight_readback.append(buf)
        
        # Weight readback 완료 ACK (옵션)
        try:
            ack = ser.readline().decode(errors='ignore').strip()
            print(f"[FPGA] {ack}")
        except:
            pass
        
        # 3-3) 최종 완료 ACK (옵션)
        try:
            final_ack = ser.readline().decode(errors='ignore').strip()
            print(f"[FPGA] {final_ack}")
        except:
            pass
        
        
        # ===== STEP 4: Readback 결과 저장 및 요약 =====
        # 4-1) 픽셀 Readback 저장
        with open('readback_pixels.txt', 'w') as f_px:
            for i, byte_group in enumerate(pixel_readback):
                r, g, b, pad = byte_group
                f_px.write(f"Pixel {i:04d}: [{r:02X},{g:02X},{b:02X},{pad:02X}]\n")
        
        # 4-2) Weight Readback 저장
        with open('readback_weights.txt', 'w') as f_wrb:
            for i, byte_group in enumerate(weight_readback):
                # big-endian signed int8 4개로 해석
                w0, w1, w2, w3 = struct.unpack('>bbbb', byte_group) 
                f_wrb.write(f"Weight {i:04d}: [{w0:4d}, {w1:4d}, {w2:4d}, {w3:4d}]\n")
        
        # 4-3) 최종 요약 출력
        print(f"\n=== 최종 결과 ===")
        print(f"픽셀 전송: {len(pixels)}개 / 수신: {len(pixel_readback)}개")
        print(f"Weight 전송 그룹: {total_weight_groups}개 / 수신: {len(weight_readback)}개")
        print(f"픽셀 개수 일치: {'✓' if len(pixels) == len(pixel_readback) else '✗'}")
        print(f"Weight 개수 일치: {'✓' if total_weight_groups == len(weight_readback) else '✗'}")
    
    except Exception as e:
        print(f"전송 중 오류: {e}")
    
    finally:
        ser.close()
        print("\nUART 포트 닫음. 종료.")

# --------------------------
# 사용 예시
# --------------------------
if __name__ == "__main__":
    image_path = './butterfly.png'
    
    weight_files = [
        './int8_params_scale_fixed_retraining/conv_first.0_weight.csv',
        './int8_params_scale_fixed_retraining/conv_first.0_bias.csv',
        './int8_params_scale_fixed_retraining/conv_first.1_a    lpha.csv',
        './int8_params_scale_fixed_retraining/conv_shrink.0_weight.csv',
        './int8_params_scale_fixed_retraining/conv_shrink.0_bias.csv',
        './int8_params_scale_fixed_retraining/conv_shrink.1_alpha.csv',
        './int8_params_scale_fixed_retraining/conv_mapping.0_weight.csv',
        './int8_params_scale_fixed_retraining/conv_mapping.0_bias.csv',
        './int8_params_scale_fixed_retraining/conv_mapping.1_weight.csv',
        './int8_params_scale_fixed_retraining/conv_mapping.1_bias.csv',
        './int8_params_scale_fixed_retraining/conv_mapping.2_weight.csv',
        './int8_params_scale_fixed_retraining/conv_mapping.2_bias.csv',
        './int8_params_scale_fixed_retraining/conv_mapping.3_weight.csv',
        './int8_params_scale_fixed_retraining/conv_mapping.3_bias.csv',
        './int8_params_scale_fixed_retraining/conv_mapping.4_alpha.csv',
        './int8_params_scale_fixed_retraining/conv_expanding.0_weight.csv',
        './int8_params_scale_fixed_retraining/conv_expanding.0_bias.csv',
        './int8_params_scale_fixed_retraining/conv_expanding.1_alpha.csv',
    ]

    conv_last_files = [
        './int8_params_scale_fixed_retraining/conv_last_weight.csv',
        './int8_params_scale_fixed_retraining/conv_last_bias.csv'
    ]
    
    # 존재하는 파일만 필터링
    existing_weights      = [f for f in weight_files if os.path.exists(f)]
    existing_conv_last    = [f for f in conv_last_files if os.path.exists(f)]
    
    if os.path.exists(image_path) and (existing_weights or existing_conv_last):
        transfer_image_and_weights(image_path, existing_weights, existing_conv_last)
    else:
        print("필요한 파일(이미지/CSV)이 누락되었습니다. 경로를 확인하세요.")
