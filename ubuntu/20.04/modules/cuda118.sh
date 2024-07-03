#!/bin/bash

alias cc="gcc-12"

sudo apt-mark unhold \
cuda \
cuda-drivers \
cuda-drivers-535 \
cuda-toolkit-config-common \
nvidia-modprobe \
nvidia-settings \
libxnvctrl0 \
cuda-toolkit-11-config-common

sudo apt purge ~nnvidia

#sudo aptitude purge ~ncuda
sudo apt purge -y --allow-change-held-packages \
"libxnvctrl0" "*cuda*" "*cudnn*" "*nvidia*" "*nsight*" "libcublas*"

sudo apt autoremove -y
sudo apt clean -y

mkdir -p ~/lib/nvidia
cd ~/lib/nvidia

if [ -f "cuda-keyring_1.1-1_all.deb" ]; then
    echo "cuda-keyring_1.1-1_all.deb exists."
else
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
fi

sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt update

sudo apt install -y --allow-downgrades \
cuda=11.8.0-1 \
cuda-toolkit-11-8 \
cuda-compiler-11-8 \
cuda-nvcc-11-8 \
cuda-11-8=11.8.0-1 \
cuda-runtime-11-8=11.8.0-1 \
cuda-demo-suite-11-8=11.8.86-1 \
cuda-drivers=535.183.01-1 \
cuda-drivers-535=535.183.01-1 \
cuda-toolkit-config-common=11.8.89-1 \
cuda-toolkit-11-config-common=11.8.89-1 \
libnvidia-cfg1-535=535.183.01-0ubuntu1 \
libnvidia-common-535=535.183.01-0ubuntu1 \
libnvidia-compute-535=535.183.01-0ubuntu1 \
libnvidia-decode-535=535.183.01-0ubuntu1 \
libnvidia-encode-535=535.183.01-0ubuntu1 \
libnvidia-extra-535=535.183.01-0ubuntu1 \
libnvidia-fbc1-535=535.183.01-0ubuntu1 \
libnvidia-gl-535=535.183.01-0ubuntu1 \
nvidia-compute-utils-535=535.183.01-0ubuntu1 \
nvidia-dkms-535=535.183.01-0ubuntu1 \
nvidia-driver-535=535.183.01-0ubuntu1 \
nvidia-kernel-common-535=535.183.01-0ubuntu1 \
nvidia-kernel-source-535=535.183.01-0ubuntu1 \
nvidia-modprobe=535.183.01-0ubuntu1 \
nvidia-settings=535.183.01-0ubuntu1 \
nvidia-utils-535=535.183.01-0ubuntu1 \
xserver-xorg-video-nvidia-535=535.183.01-0ubuntu1 \
libxnvctrl0=535.183.01-0ubuntu1

sudo apt-mark hold \
cuda \
cuda-drivers \
cuda-drivers-535 \
cuda-toolkit-config-common \
cuda-toolkit-11-config-common \
libnvidia-cfg1-535 \
libnvidia-common-535 \
libnvidia-compute-535 \
libnvidia-decode-535 \
libnvidia-encode-535 \
libnvidia-extra-535 \
libnvidia-fbc1-535 \
libnvidia-gl-535 \
nvidia-compute-utils-535 \
nvidia-dkms-535 \
nvidia-driver-535 \
nvidia-kernel-common-535 \
nvidia-kernel-source-535 \
nvidia-modprobe \
nvidia-settings \
nvidia-utils-535 \
xserver-xorg-video-nvidia-535 \
libxnvctrl0

if ! grep -Fxq "## CUDA and cuDNN paths" ~/.bashrc
then
    echo -e "\n## CUDA and cuDNN paths"  >> ~/.bashrc
    echo 'export PATH=/usr/local/cuda-11.8/bin:${PATH}' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:${LD_LIBRARY_PATH}' >> ~/.bashrc
    source ~/.bashrc # reload .bashrc with cuda path
fi
