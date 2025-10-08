#!/bin/bash

sudo apt install -y gcc-12 g++-12
alias cc="gcc-12"

# Rermove nvidia packages
sudo apt-mark unhold cuda* cudnn* nvidia* libnvidia* xserver-xorg-video-nvidia* libxnvctrl*
sudo apt purge -y --allow-change-held-packages "*cuda*" "*cudnn*" "*nvidia*" "*nsight*" "libcublas*" "libxnvctrl*"
nvidia* \
libnvidia* \
xserver-xorg-video-nvidia* \
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
cuda-12-8 \
cuda-toolkit-12-8 \
cudnn=9.13.1-1 \
cuda-drivers-570 \
nvidia-driver-570 \

sudo apt-mark hold \
cuda-12-8 \
cuda-toolkit-12-8 \
cudnn \
cuda-drivers-570 \
nvidia-driver-570

if ! grep -Fxq "## CUDA and cuDNN paths" ~/.bashrc
then
    echo -e "\n## CUDA and cuDNN paths"  >> ~/.bashrc
    echo 'export PATH=/usr/local/cuda-12.8/bin:${PATH}' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64:${LD_LIBRARY_PATH}' >> ~/.bashrc
    source ~/.bashrc # reload .bashrc with cuda path
fi

# Reinstall mouse and keyboard input
sudo apt install xserver-xorg-input-all --reinstall
