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

# Install cuda (CUDA 12.8.1 / driver 580.159.04, ubuntu2204 repo で実在確認済み)
# 12.8.0 を使う場合: toolkit/compiler=12.8.0-1, nvcc=12.8.61-1, config-common=12.8.57-1
# 12.8.2 を使う場合: toolkit/compiler=12.8.2-1, nvcc は 12.8.2 用が無いため madison で要確認
sudo apt install -y --allow-downgrades --allow-change-held-packages \
cuda-toolkit-12-8=12.8.1-1 \
cuda-compiler-12-8=12.8.1-1 \
cuda-nvcc-12-8=12.8.93-1 \
cuda-toolkit-config-common=12.8.90-1 \
cuda-toolkit-12-8-config-common=12.8.90-1 \
libnvidia-cfg1-580=580.159.04-1ubuntu1 \
libnvidia-common-580=580.159.04-1ubuntu1 \
libnvidia-compute-580=580.159.04-1ubuntu1 \
libnvidia-decode-580=580.159.04-1ubuntu1 \
libnvidia-encode-580=580.159.04-1ubuntu1 \
libnvidia-extra-580=580.159.04-1ubuntu1 \
libnvidia-fbc1-580=580.159.04-1ubuntu1 \
libnvidia-gl-580=580.159.04-1ubuntu1 \
nvidia-compute-utils-580=580.159.04-1ubuntu1 \
nvidia-dkms-580-open=580.159.04-1ubuntu1 \
nvidia-driver-580-open=580.159.04-1ubuntu1 \
nvidia-kernel-common-580=580.159.04-1ubuntu1 \
nvidia-kernel-source-580-open=580.159.04-1ubuntu1 \
nvidia-modprobe=580.159.04-1ubuntu1 \
nvidia-settings=580.159.04-1ubuntu1 \
nvidia-utils-580=580.159.04-1ubuntu1 \
xserver-xorg-video-nvidia-580=580.159.04-1ubuntu1 \
libxnvctrl0=580.159.04-1ubuntu1

sudo apt-mark hold \
cuda-toolkit-12-8 \
cuda-compiler-12-8 \
cuda-nvcc-12-8 \
cuda-toolkit-config-common \
cuda-toolkit-12-8-config-common \
libnvidia-cfg1-580 \
libnvidia-common-580 \
libnvidia-compute-580 \
libnvidia-decode-580 \
libnvidia-encode-580 \
libnvidia-extra-580 \
libnvidia-fbc1-580 \
libnvidia-gl-580 \
nvidia-compute-utils-580 \
nvidia-dkms-580-open \
nvidia-driver-580-open \
nvidia-kernel-common-580 \
nvidia-kernel-source-580-open \
nvidia-modprobe \
nvidia-settings \
nvidia-utils-580 \
xserver-xorg-video-nvidia-580 \
libxnvctrl0

if ! grep -Fxq "## CUDA and cuDNN paths" ~/.bashrc
then
    echo -e "\n## CUDA and cuDNN paths"  >> ~/.bashrc
    echo 'export PATH=/usr/local/cuda-12.8/bin:${PATH}' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64:${LD_LIBRARY_PATH}' >> ~/.bashrc
    source ~/.bashrc # reload .bashrc with cuda path
fi

# Reinstall mouse and keyboard input
sudo apt install xserver-xorg-input-all --reinstall
