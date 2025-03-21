import os
import random
import torch
import torch.nn as nn
import torch.optim as optim
from tqdm import tqdm
from torch.utils.data import DataLoader
import matplotlib.pyplot as plt

from dataset import SRDataset
from model import FSRCNN

# -------------------------
# 학습 함수 정의
# -------------------------

def train_model(model, dataloader, criterion, optimizer, num_epochs, checkpoint_dir, device):
    model.to(device)
    loss_history = []

    for epoch in range(num_epochs):
        model.train()
        running_loss = 0.0
        
        # tqdm을 사용해서 배치 단위 진행 상황 표시
        for i, (lr, hr) in enumerate(tqdm(dataloader, desc=f"Epoch {epoch+1}/{num_epochs}")):
            lr = lr.to(device)
            hr = hr.to(device)

            optimizer.zero_grad()
            sr = model(lr)
            loss = criterion(sr, hr)
            loss.backward()
            optimizer.step()

            running_loss += loss.item() * lr.size(0)

        epoch_loss = running_loss / len(dataloader.dataset)
        loss_history.append(epoch_loss)
        print(f'Epoch [{epoch+1}/{num_epochs}], Loss: {epoch_loss:.6f}')

        # 체크포인트 저장
        ckpt_path = os.path.join(checkpoint_dir, f'checkpoint_epoch_{epoch+1}.pth')
        torch.save({
            'epoch': epoch + 1,
            'model_state_dict': model.state_dict(),
            'optimizer_state_dict': optimizer.state_dict(),
            'loss': epoch_loss,
        }, ckpt_path)

    # 학습 loss 시각화
    plt.figure()
    plt.plot(range(1, num_epochs+1), loss_history, label='Training Loss')
    plt.xlabel('Epoch')
    plt.ylabel('Loss')
    plt.title('Training Loss History')
    plt.legend()
    plt.show()

    return loss_history

# -------------------------
# 메인 학습 코드
# -------------------------
if __name__ == '__main__':
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    # 데이터셋 경로 (각자 환경에 맞게 수정)
    dataset_91_dir = '/FSRCNN_dataset/total_dataset/T91'
    dataset_general_dir = '/FSRCNN_dataset/total_dataset/General100'
    dataset_total_dir = '/FSRCNN_dataset/total_dataset/T91PlusGeneral100'

    # 체크포인트 저장 경로
    checkpoint_dir = '/content/drive/MyDrive/FSRCNN_checkpoints'
    os.makedirs(checkpoint_dir, exist_ok=True)

    # 기본 하이퍼파라미터 설정
    patch_size = 48          # LR 패치 크기
    scale_factor = 3         # 초기 학습은 x3
    batch_size = 16
    num_epochs_initial = 50  # 91-image dataset으로 초기 학습 (예시)

    # 91-image dataset을 이용하여 DataLoader 구성
    train_dataset = SRDataset(image_dir=dataset_91_dir, patch_size=patch_size, scale_factor=scale_factor, augment=True)
    train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True, num_workers=4)

    # FSRCNN 모델 초기화 (x3 학습)
    model = FSRCNN(scale_factor=scale_factor, d=56, s=12, m=4)

    # 손실 함수 (MSE)
    criterion = nn.MSELoss()

    # optimizer를 parameter group으로 구성: 
    # convolution 계층들은 lr=0.001, deconvolution 계층은 lr=0.0001
    optimizer = optim.Adam([
        {'params': model.conv_first.parameters(), 'lr': 0.001},
        {'params': model.conv_shrink.parameters(), 'lr': 0.001},
        {'params': model.conv_mapping.parameters(), 'lr': 0.001},
        {'params': model.conv_expanding.parameters(), 'lr': 0.001},
        {'params': model.deconv.parameters(), 'lr': 0.0001},
    ])

    # 91-image dataset으로 기본 학습 진행 (x3)
    print("Starting initial training on 91-image dataset (scale x3)...")
    checkpoint_dir_x3 = '/content/drive/MyDrive/FSRCNN_checkpoints/x3'
    loss_history_initial = train_model(model, train_loader, criterion, optimizer, num_epochs_initial, checkpoint_dir_x3, device)

    # -------------------------
    # fine-tuning: general-100 dataset으로 모든 layer의 lr를 절반으로 줄여서 fine-tuning
    # -------------------------
    # 각 parameter group의 lr를 절반으로 업데이트
    for param_group in optimizer.param_groups:
        param_group['lr'] *= 0.5

    # general-100 dataset의 DataLoader 구성
    fine_tune_dataset = SRDataset(image_dir=dataset_general_dir, patch_size=patch_size, scale_factor=scale_factor, augment=True)
    fine_tune_loader = DataLoader(fine_tune_dataset, batch_size=batch_size, shuffle=True, num_workers=4)

    num_epochs_finetune = 20  # 예시
    print("Starting fine-tuning on general-100 dataset (scale x3)...")
    checkpoint_dir_x3_fine_tuned = '/content/drive/MyDrive/FSRCNN_checkpoints/x3_fine_tuned'
    loss_history_finetune = train_model(model, fine_tune_loader, criterion, optimizer, num_epochs_finetune, checkpoint_dir_x3_fine_tuned, device)

    # -------------------------
    # 추가 fine-tuning: x2, x4에 대해 deconvolution만 업데이트 (convolution 계층은 고정)
    # -------------------------
    # 예시: scale factor x2 (저해상도 이미지 → x2 업샘플링)
    scale_factor_new = 2
    # x3 모델에서 convolution 계층은 그대로 transfer
    model_x2 = FSRCNN(scale_factor=scale_factor_new, d=56, s=12, m=4)
    model_x2.conv_first.load_state_dict(model.conv_first.state_dict())
    model_x2.conv_shrink.load_state_dict(model.conv_shrink.state_dict())
    model_x2.conv_mapping.load_state_dict(model.conv_mapping.state_dict())
    model_x2.conv_expanding.load_state_dict(model.conv_expanding.state_dict())
    # convolution 계층 freeze
    for param in model_x2.conv_first.parameters():
        param.requires_grad = False
    for param in model_x2.conv_shrink.parameters():
        param.requires_grad = False
    for param in model_x2.conv_mapping.parameters():
        param.requires_grad = False
    for param in model_x2.conv_expanding.parameters():
        param.requires_grad = False

    # deconvolution만 업데이트하도록 optimizer 구성
    optimizer_x2 = optim.Adam(model_x2.deconv.parameters(), lr=0.0001)
    train_dataset_x2 = SRDataset(image_dir=dataset_total_dir, patch_size=patch_size, scale_factor=scale_factor_new, augment=True)
    train_loader_x2 = DataLoader(train_dataset_x2, batch_size=batch_size, shuffle=True, num_workers=4)
    num_epochs_x2 = 20
    print("Starting fine-tuning of deconvolution for scale x2...")
    checkpoint_dir_x2 = '/content/drive/MyDrive/FSRCNN_checkpoints/x2'
    loss_history_x2 = train_model(model_x2, train_loader_x2, criterion, optimizer_x2, num_epochs_x2, checkpoint_dir_x2, device)

    # 예시: scale factor x4 (동일한 방식)
    scale_factor_new = 4
    model_x4 = FSRCNN(scale_factor=scale_factor_new, d=56, s=12, m=4)
    model_x4.conv_first.load_state_dict(model.conv_first.state_dict())
    model_x4.conv_shrink.load_state_dict(model.conv_shrink.state_dict())
    model_x4.conv_mapping.load_state_dict(model.conv_mapping.state_dict())
    model_x4.conv_expanding.load_state_dict(model.conv_expanding.state_dict())
    for param in model_x4.conv_first.parameters():
        param.requires_grad = False
    for param in model_x4.conv_shrink.parameters():
        param.requires_grad = False
    for param in model_x4.conv_mapping.parameters():
        param.requires_grad = False
    for param in model_x4.conv_expanding.parameters():
        param.requires_grad = False
    optimizer_x4 = optim.Adam(model_x4.deconv.parameters(), lr=0.0001)
    train_dataset_x4 = SRDataset(image_dir=dataset_total_dir, patch_size=patch_size, scale_factor=scale_factor_new, augment=True)
    train_loader_x4 = DataLoader(train_dataset_x4, batch_size=batch_size, shuffle=True, num_workers=4)
    num_epochs_x4 = 20
    print("Starting fine-tuning of deconvolution for scale x4...")
    checkpoint_dir_x4 = '/content/drive/MyDrive/FSRCNN_checkpoints/x4'
    loss_history_x4 = train_model(model_x4, train_loader_x4, criterion, optimizer_x4, num_epochs_x4, checkpoint_dir_x4, device)
