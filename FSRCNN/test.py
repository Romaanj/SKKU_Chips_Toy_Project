import torch
import matplotlib.pyplot as plt
from PIL import Image
import torchvision.transforms as transforms

from model import FSRCNN

# device 설정
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# 모델 인스턴스 생성 (예: FSRCNN, 학습 시 사용한 scale_factor와 동일하게)
model = FSRCNN(scale_factor=3, d=56, s=12, m=4)
model.to(device)
model.eval()

# 학습된 체크포인트 불러오기 (원하는 checkpoint 파일 경로로 수정)
checkpoint = torch.load('/FSRCNN_checkpoints/x3_fine_tuned/checkpoint_epoch_20.pth', map_location=device)
model.load_state_dict(checkpoint['model_state_dict'])

# 이미지 전처리 정의: PIL Image → Tensor
to_tensor = transforms.ToTensor()
to_pil = transforms.ToPILImage()

# 테스트용 LR 이미지 로드 (예시)
lr_image_path = '/FSRCNN_dataset/total_dataset/Set5/LRbicx3/butterfly.png'
lr_image = Image.open(lr_image_path).convert('RGB')

# LR 이미지 전처리 및 배치 차원 추가
lr_tensor = to_tensor(lr_image).unsqueeze(0).to(device)

# 모델 추론 (torch.no_grad() 블록 내에서 진행)
with torch.no_grad():
    sr_tensor = model(lr_tensor)

# SR 텐서를 PIL Image로 변환
sr_image = to_pil(sr_tensor.squeeze(0).cpu())

# 결과 시각화: 입력 LR, 출력 SR, (옵션: ground truth HR)
plt.figure(figsize=(15, 5))
plt.subplot(1, 2, 1)
plt.imshow(lr_image)
plt.title("Input LR")
plt.axis('off')

plt.subplot(1, 2, 2)
plt.imshow(sr_image)
plt.title("Output SR")
plt.axis('off')

plt.show()
