import os
import random
import torch
import torch.nn as nn
import torch.optim as optim
from tqdm import tqdm
from torch.utils.data import DataLoader
import matplotlib.pyplot as plt

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

        psnr_set14 = validate(model, set14_loader, device, scale_factor)
        print(f'Set14 x3 PSNR: {psnr_set14:.2f} dB')

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

    # 데이터셋 경로 (각자 환경에 맞게 수정)-train
    dataset_91_dir = '/content/drive/MyDrive/FSRCNN_dataset/total_dataset/T91'
    dataset_general_dir = '/content/drive/MyDrive/FSRCNN_dataset/total_dataset/General100'
    dataset_total_dir = '/content/drive/MyDrive/FSRCNN_dataset/total_dataset/T91PlusGeneral100'

    # 체크포인트 저장 경로
    checkpoint_dir = '/content/drive/MyDrive/FSRCNN_Retraining_Checkpoints'
    os.makedirs(checkpoint_dir, exist_ok=True)

    # 기본 하이퍼파라미터 설정
    patch_size = 72          # LR 패치 크기
    scale_factor = 3         # 초기 학습은 x3
    batch_size = 16
    num_epochs_initial = 50  # 91-image dataset으로 초기 학습 

    # 91-image dataset을 이용하여 DataLoader 구성 - train
    train_dataset = SRDataset(image_dir=dataset_91_dir, patch_size=patch_size, scale_factor=scale_factor, augment=True)
    train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True, num_workers=4)

    # set5/set14 dataset을 이용하여 DataLoader 구성 - Test
    # Set14 테스트셋 준비
    set14_lr_dir = '/content/drive/MyDrive/FSRCNN_dataset/total_dataset/Set14/LRbicx3'
    set14_hr_dir = '/content/drive/MyDrive/FSRCNN_dataset/total_dataset/Set14/original'
    test_transform = transforms.ToTensor()  # [0,255]→[0,1]
    set14_test = TestDataset(set14_lr_dir, set14_hr_dir, transform=test_transform)
    set14_loader = DataLoader(set14_test, batch_size=1, shuffle=False, num_workers=2)


    # FSRCNN 모델 초기화 (x3 학습)
    model = FSRCNN_QAT(scale_factor=scale_factor, d=56, s=12, m=4)

    # fixed-scale 값 할당
    model.conv_first[0].fixed_scale      = torch.tensor(1/256)
    model.conv_shrink[0].fixed_scale     = torch.tensor(1/256)
    model.conv_mapping[0].fixed_scale    = torch.tensor(1/1024)
    model.conv_mapping[1].fixed_scale    = torch.tensor(1/1024)
    model.conv_mapping[2].fixed_scale    = torch.tensor(1/512)
    model.conv_mapping[3].fixed_scale    = torch.tensor(1/1024)
    model.conv_expanding[0].fixed_scale  = torch.tensor(1/256)
    model.conv_last.fixed_scale          = torch.tensor(1/4096)

    # PReLU scales:
    model.conv_first[1].fixed_alpha_scale   = torch.tensor(1/128)
    model.conv_shrink[1].fixed_alpha_scale  = torch.tensor(1/256)
    model.conv_mapping[4].fixed_alpha_scale = torch.tensor(1/512)
    model.conv_expanding[1].fixed_alpha_scale = torch.tensor(1/256)

    # 손실 함수 (MSE)
    criterion = nn.MSELoss()

    # optimizer를 parameter group으로 구성:
    optimizer = optim.AdamW([
        {'params': model.conv_first.parameters(), 'lr': 0.001},
        {'params': model.conv_shrink.parameters(), 'lr': 0.001},
        {'params': model.conv_mapping.parameters(), 'lr': 0.001},
        {'params': model.conv_expanding.parameters(), 'lr': 0.001},
        {'params': model.conv_last.parameters(), 'lr': 0.0001},
    ])

    # 91-image dataset으로 기본 학습 진행 (x3)
    print("Starting initial training on 91-image dataset (scale x3)...")
    checkpoint_dir_x3 = '/content/drive/MyDrive/FSRCNN_QAT_Checkpoints/x3_scale_fixed_retraining'
    os.makedirs(checkpoint_dir_x3, exist_ok=True)
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
    checkpoint_dir_x3_fine_tuned = '/content/drive/MyDrive/FSRCNN_QAT_Checkpoints/x3_fine_tuned_scale_fixed_retraining'
    os.makedirs(checkpoint_dir_x3_fine_tuned, exist_ok=True)
    loss_history_finetune = train_model(model, fine_tune_loader, criterion, optimizer, num_epochs_finetune, checkpoint_dir_x3_fine_tuned, device)
