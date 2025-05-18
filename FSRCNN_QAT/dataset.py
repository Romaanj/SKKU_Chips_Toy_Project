import os
import random
from PIL import Image
import torch
from torch.utils.data import Dataset
import torchvision.transforms as transforms
import torchvision.transforms.functional as TF
from glob import glob
from torch.utils.data import Dataset, DataLoader

class SRDataset(Dataset):
    def __init__(self, image_dir, patch_size, scale_factor, augment=True):
        """
        augment=True인 경우, 각 이미지에 대해 원본 + 미리 정의된 증강 조합을 모두 적용.
        스케일: [1.0, 0.9, 0.8, 0.7, 0.6], 회전: [0, 90, 180, 270] → 총 20 조합 중 (1.0,0°)는 원본이므로 추가 19개
        """
        super(SRDataset, self).__init__()
        # general-100 + T91 dataset image_path 모두 가져오기
        self.image_paths = [
            os.path.join(image_dir, x)
            for x in os.listdir(image_dir)
              if x.lower().endswith(('.png', '.jpg', '.jpeg'))
        ] # total size : 191
        self.patch_size = patch_size                   # LR 패치 크기
        self.scale_factor = scale_factor
        self.hr_patch_size = patch_size * scale_factor # HR 패치 크기
        self.augment = augment
        # 증강 조합 정의: 원본 포함해서 총 20 조합, 단 (1.0, 0°)는 원본으로 처리
        self.scale_aug_factors = [1.0, 0.9, 0.8, 0.7, 0.6]
        self.rotation_angles = [0, 90, 180, 270]
        self.aug_combinations = []  # (scale, rotation) 조합 (원본은 따로 처리)
        if self.augment:
            for s in self.scale_aug_factors:
                for r in self.rotation_angles:
                    # (1.0, 0°)는 원본
                    if s == 1.0 and r == 0:
                        continue
                    self.aug_combinations.append((s, r))
        self.to_tensor = transforms.ToTensor()

    def __len__(self):
        # 원본 이미지 + 증강 조합 개수 만큼 확장
        if self.augment:
            return len(self.image_paths) * (1 + len(self.aug_combinations)) # 191 * (1 + 19)
        else:
            return len(self.image_paths)

    def __getitem__(self, idx):
        if self.augment:
            # 각 이미지에 대해 (원본 + 증강) 순서대로 할당
            base_idx = idx // (1 + len(self.aug_combinations)) # idx // 20
            aug_idx = idx % (1 + len(self.aug_combinations))   # idx % 20
        else:
            base_idx = idx
            aug_idx = 0

        hr_image = Image.open(self.image_paths[base_idx]).convert('RGB')

        # 증강 적용: aug_idx == 0이면 원본, 그 외는 해당 조합 적용
        if self.augment and aug_idx != 0:
            scale_aug, angle = self.aug_combinations[aug_idx - 1]
            # 스케일 증강 (1.0이면 변경 없음)
            if scale_aug != 1.0:
                new_w = int(hr_image.width * scale_aug)
                new_h = int(hr_image.height * scale_aug)
                hr_image = hr_image.resize((new_w, new_h), Image.BICUBIC)
            # 회전 증강 (0도이면 변경 없음)
            if angle != 0:
                hr_image = hr_image.rotate(angle, expand=True)

        # HR 이미지로부터 LR 이미지 생성 (bicubic interpolation)
        lr_w = hr_image.width // self.scale_factor
        lr_h = hr_image.height // self.scale_factor
        lr_image = hr_image.resize((lr_w, lr_h), Image.BICUBIC)

        # 랜덤 crop (혹은 고정 crop)을 적용하여 LR/HR 패치 쌍 추출
        if lr_w < self.patch_size or lr_h < self.patch_size:
            hr_image = hr_image.resize((self.hr_patch_size, self.hr_patch_size), Image.BICUBIC)
            lr_image = hr_image.resize((self.patch_size, self.patch_size), Image.BICUBIC)
        else:
            x = random.randint(0, lr_w - self.patch_size)
            y = random.randint(0, lr_h - self.patch_size)
            lr_patch = lr_image.crop((x, y, x + self.patch_size, y + self.patch_size))
            hr_x = x * self.scale_factor
            hr_y = y * self.scale_factor
            hr_patch = hr_image.crop((hr_x, hr_y, hr_x + self.hr_patch_size, hr_y + self.hr_patch_size))
            lr_image = lr_patch
            hr_image = hr_patch

        lr_tensor = self.to_tensor(lr_image)
        hr_tensor = self.to_tensor(hr_image)
        return lr_tensor, hr_tensor


class TestDataset(Dataset):
    def __init__(self, lr_dir, hr_dir, transform=None):
        # LR/HR 경로를 알파벳 순으로 정렬해서 인덱스별로 짝이 맞게
        self.lr_paths = sorted(glob(os.path.join(lr_dir, '*')))
        self.hr_paths = sorted(glob(os.path.join(hr_dir, '*')))
        assert len(self.lr_paths) == len(self.hr_paths), "LR/HR 개수가 달라요!"
        self.transform = transform or transforms.ToTensor()

    def __len__(self):
        return len(self.lr_paths)

    def __getitem__(self, idx):
        lr = Image.open(self.lr_paths[idx]).convert('RGB')
        hr = Image.open(self.hr_paths[idx]).convert('RGB')
        return self.transform(lr), self.transform(hr)

