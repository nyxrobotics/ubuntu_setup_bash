#!/bin/bash

sudo apt install -y gcc-12 g++-12
alias cc="gcc-12"

# Rermove nvidia packages
sudo apt-mark unhold cuda* cudnn* nvidia* libnvidia* xserver-xorg-video-nvidia* libxnvctrl*
sudo apt purge -y --allow-change-held-packages "*cuda*" "*cudnn*" "*nvidia*" "*nsight*" "libcublas*" "libxnvctrl*" "nvidia*" "libnvidia*" "xserver-xorg-video-nvidia*"
sudo apt autoremove -y
sudo apt clean -y
sudo apt update
sudo apt install -f
sudo dpkg --configure -a

# Install cuda-keyring
mkdir -p ~/lib/nvidia
cd ~/lib/nvidia
if [ -f "cuda-keyring_1.1-1_all.deb" ]; then
    echo "cuda-keyring_1.1-1_all.deb exists."
else
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
fi
sudo dpkg -i cuda-keyring_1.1-1_all.deb;sudo apt update

# Install libssl1.1
sudo add-apt-repository -y ppa:nrbrtx/libssl1
sudo apt update
sudo apt install -y libssl1.1

# Install cuda (CUDA 12.2.2 / driver 550.163.01, ubuntu2204 repo で実在確認済み)
# 12.2.0 を使う場合: nvcc=12.2.91-1, demo-suite=12.2.53-1, config-common=12.2.53-1
# 12.2.1 を使う場合: nvcc=12.2.128-1, demo-suite=12.2.128-1, config-common=12.2.128-1
sudo apt install -y --allow-downgrades --allow-change-held-packages \
cuda-toolkit-12-2=12.2.2-1 \
cuda-compiler-12-2=12.2.2-1 \
cuda-nvcc-12-2=12.2.140-1 \
cuda-toolkit-config-common=12.2.140-1 \
cuda-toolkit-12-2-config-common=12.2.140-1 \
libnvidia-cfg1-550=550.163.01-0ubuntu1 \
libnvidia-common-550=550.163.01-0ubuntu1 \
libnvidia-compute-550=550.163.01-0ubuntu1 \
libnvidia-decode-550=550.163.01-0ubuntu1 \
libnvidia-encode-550=550.163.01-0ubuntu1 \
libnvidia-extra-550=550.163.01-0ubuntu1 \
libnvidia-fbc1-550=550.163.01-0ubuntu1 \
libnvidia-gl-550=550.163.01-0ubuntu1 \
nvidia-compute-utils-550=550.163.01-0ubuntu1 \
nvidia-dkms-550-open=550.163.01-0ubuntu1 \
nvidia-driver-550-open=550.163.01-0ubuntu1 \
nvidia-kernel-common-550=550.163.01-0ubuntu1 \
nvidia-kernel-source-550-open=550.163.01-0ubuntu1 \
nvidia-modprobe=550.163.01-0ubuntu1 \
nvidia-settings=550.163.01-0ubuntu1 \
nvidia-utils-550=550.163.01-0ubuntu1 \
xserver-xorg-video-nvidia-550=550.163.01-0ubuntu1 \
libxnvctrl0=550.163.01-0ubuntu1

sudo apt-mark hold \
cuda-toolkit-12-2 \
cuda-compiler-12-2 \
cuda-nvcc-12-2 \
cuda-toolkit-config-common \
cuda-toolkit-12-2-config-common \
libnvidia-cfg1-550 \
libnvidia-common-550 \
libnvidia-compute-550 \
libnvidia-decode-550 \
libnvidia-encode-550 \
libnvidia-extra-550 \
libnvidia-fbc1-550 \
libnvidia-gl-550 \
nvidia-compute-utils-550 \
nvidia-dkms-550-open \
nvidia-driver-550-open \
nvidia-kernel-common-550 \
nvidia-kernel-source-550-open \
nvidia-modprobe \
nvidia-settings \
nvidia-utils-550 \
xserver-xorg-video-nvidia-550 \
libxnvctrl0

if ! grep -Fxq "## CUDA and cuDNN paths" ~/.bashrc
then
    echo -e "\n## CUDA and cuDNN paths"  >> ~/.bashrc
    echo 'export PATH=/usr/local/cuda-12.2/bin:${PATH}' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64:${LD_LIBRARY_PATH}' >> ~/.bashrc
    source ~/.bashrc # reload .bashrc with cuda path
fi

# Reinstall mouse and keyboard input
sudo apt install xserver-xorg-input-all --reinstall