import sys
import torch.utils.benchmark as benchmark

sys.path.append(r'C:\Users\송성민\Desktop\SKKU_CHIPS\SKKU_Chips_Toy_Project\File Extractor')
from Output_Extractor_From_QAT_Model import *

"""
BENCHMARK METHODOLOGY: torch.utils.benchmark
"""

LR_path = r'C:\Users\송성민\Desktop\SKKU_CHIPS\Set5\LRbicx3\butterfly.png'
LR = Read_LR_Image_Return_Quantized_Input_Tensor(LR_path, 7)

checkpoint_path = r"C:\Users\송성민\Desktop\SKKU_CHIPS\checkpoints_QAT\checkpoint_epoch_50_1.pth"

int8_model = torch.load(checkpoint_path, map_location='cpu', weights_only=False)
int8_model.eval()

def WRAPPER_FSRCNN_QAT(lr_tensor):
    out1 = int8_model.conv_first(lr_tensor)
    out2 = int8_model.conv_shrink(out1)
    out = out2
    for i, layer in enumerate(int8_model.conv_mapping):
        out = layer(out)
    out3 = int8_model.conv_expanding(out)
    out4 = int8_model.upsample(out3)
    out5 = int8_model.conv_last(out4)
    return out5

t1 = benchmark.Timer(
    stmt='WRAPPER_FSRCNN_QAT(lr_tensor)',
    setup='from __main__ import WRAPPER_FSRCNN_QAT',
    globals={'lr_tensor': LR}
    )

print(t1.blocked_autorange(min_run_time=100))
