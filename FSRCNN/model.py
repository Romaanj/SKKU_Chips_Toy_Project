import torch
import torch.nn as nn

class FSRCNN(nn.Module):
  def __init__(self, scale_factor = 3, num_channels=3, d=56, s=12, m=4):
    super(FSRCNN, self).__init__()
    # Conv(5,d,1)
    self.conv_first = nn.Sequential(
        nn.Conv2d(num_channels, d, kernel_size=5, padding=5//2),
        nn.PReLU(d)
    )
    # Conv(1,s,d)
    self.conv_shrink = nn.Sequential(
        nn.Conv2d(d, s, kernel_size=1),
        nn.PReLU(s)
    )
    # Conv(3,s,s) * m
    self.conv_mapping = nn.Sequential(
        *[nn.Conv2d(s, s, kernel_size=3, padding=3//2) for _ in range(m)],
        nn.PReLU(s)
    )
    # Conv(1,d,s)
    self.conv_expanding = nn.Sequential(
        nn.Conv2d(s, d, kernel_size=1),
        nn.PReLU(d)
    )
    # DeConv(9,1,d)
    self.deconv = nn.ConvTranspose2d(d, num_channels, kernel_size=9, stride=scale_factor, padding=9//2, output_padding=scale_factor-1)

  def forward(self, x):
    x = self.conv_first(x)
    x = self.conv_shrink(x)
    x = self.conv_mapping(x)
    x = self.conv_expanding(x)
    x = self.deconv(x)
    return x
