# 📌 FSRCNN for Image Super-Resolution

This repository contains a PyTorch implementation of the Fast Super-Resolution Convolutional Neural Network (FSRCNN) for image super-resolution.

## Overview

FSRCNN is a lightweight and fast convolutional network for image super-resolution. This project includes:

- **model.py**: FSRCNN network architecture.
- **train.py**: Training scripts including initial training and fine-tuning (with strategies for different scaling factors).
- **test.py**: Inference and evaluation scripts (includes PSNR calculation).
- **dataset.py**: Dataset classes for both training (with augmentation) and testing.

## Datasets
FSRCNN은 다음의 데이터셋들을 사용함

- T91 Dataset: 초기 학습에 사용.
- General-100 Dataset: fine-tuning에 사용.
- Test Datasets: Set5, Set14, BSD200 (평가용).

아래 Google Drive 링크에서 데이터셋 모두 다운로드 받을 수 있음

[Google Drive - Datasets](https://drive.google.com/drive/folders/1pRmhEmmY-tPF7uH8DuVthfHoApZWJ1QU)

## Checkpoints
Epoch 50으로 학습해서 얻은 checkpoint들을, 아래의 Google Drive 링크에서 다운로드 받을 수 있음

[Google Drive - FSRCNN Checkpoints](https://drive.google.com/drive/folders/1-iTW9oLEgwb61z9xCZGj1R3Yfk8xmvai?usp=sharing)

**checkpoint_epoch_20_scale_quantization.pth가, 최종 버전**
[Google Drive - FSRCNN_QAT_Checkpoints](https://drive.google.com/drive/folders/11lDyU3vFRGdnTkKqXconq_pI9yKaiSG2?usp=sharing)

## Article
✔️ Velog(블로그)에 개인적으로 FSRCNN 논문 리뷰한 글 링크 아래에 첨부해두었음(많관부)

[FSRCNN 논문 리뷰 및 코드 구현](https://velog.io/@jwlee1218/FSRCNN-Accelerating-the-Super-Resolution-Convolutional-Neural-Network-%EB%85%BC%EB%AC%B8-%EB%A6%AC%EB%B7%B0-%EC%BD%94%EB%93%9C-%EA%B5%AC%ED%98%84)

---
#### 최종 편집자
- 🧑‍💻 **이준원** - *25.03.22*
