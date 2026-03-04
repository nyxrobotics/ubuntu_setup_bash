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

# Install cuda
sudo apt install -y --allow-downgrades --allow-change-held-packages \
cuda=12.8.0-1 \
cuda-toolkit-12-8=12.8.0-1 \
cuda-compiler-12-8=12.8.0-1 \
cuda-nvcc-12-8=12.8.93-1 \
cuda-12-8=12.8.0-1 \
cuda-runtime-12-8=12.8.0-1 \
cuda-demo-suite-12-8=12.8.90-1 \
cuda-toolkit-config-common=12.8.90-1 \
cuda-toolkit-12-8-config-common=12.8.90-1 \
libnvidia-cfg1-570=570.133.20-0ubuntu1 \
libnvidia-common-570=570.133.20-0ubuntu1 \
libnvidia-compute-570=570.133.20-0ubuntu1 \
libnvidia-decode-570=570.133.20-0ubuntu1 \
libnvidia-encode-570=570.133.20-0ubuntu1 \
libnvidia-extra-570=570.133.20-0ubuntu1 \
libnvidia-fbc1-570=570.133.20-0ubuntu1 \
libnvidia-gl-570=570.133.20-0ubuntu1 \
nvidia-compute-utils-570=570.133.20-0ubuntu1 \
nvidia-dkms-570-open=570.133.20-0ubuntu1 \
nvidia-driver-570-open=570.133.20-0ubuntu1 \
nvidia-kernel-common-570=570.133.20-0ubuntu1 \
nvidia-kernel-source-570-open=570.133.20-0ubuntu1 \
nvidia-modprobe=570.133.20-0ubuntu1 \
nvidia-open=570.133.20-0ubuntu1 \
nvidia-settings=570.133.20-0ubuntu1 \
nvidia-utils-570=570.133.20-0ubuntu1 \
xserver-xorg-video-nvidia-570=570.133.20-0ubuntu1 \
libxnvctrl0=570.133.20-0ubuntu1

sudo apt-mark hold \
cuda \
cuda-toolkit-12-8 \
cuda-compiler-12-8 \
cuda-nvcc-12-8 \
cuda-12-8 \
cuda-runtime-12-8 \
cuda-demo-suite-12-8 \
cuda-toolkit-config-common \
cuda-toolkit-12-8-config-common \
libnvidia-cfg1-570 \
libnvidia-common-570 \
libnvidia-compute-570 \
libnvidia-decode-570 \
libnvidia-encode-570 \
libnvidia-extra-570 \
libnvidia-fbc1-570 \
libnvidia-gl-570 \
nvidia-compute-utils-570 \
nvidia-dkms-570-open \
nvidia-driver-570-open \
nvidia-kernel-common-570 \
nvidia-kernel-source-570-open \
nvidia-modprobe \
nvidia-open \
nvidia-settings \
nvidia-utils-570 \
xserver-xorg-video-nvidia-570 \
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
