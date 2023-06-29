#!/bin/bash

sudo apt-mark unhold cuda cuda-drivers cuda-toolkit-config-common nvidia-modprobe nvidia-settings
#sudo aptitude purge ~ncuda
sudo apt purge -y --allow-change-held-packages "*cuda*" "*cudnn*" "*nvidia*" "*nsight*" "libcublas*"
sudo apt autoremove -y

mkdir -p ~/lib/nvidia
cd ~/lib/nvidia

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt update
sudo apt install -y cuda=11.4.4-1 \
cuda-drivers=470.199.02-1 \
cuda-toolkit-config-common=11.4.148-1 \
nvidia-modprobe=470.199.02-0ubuntu1 \
nvidia-settings=470.199.02-0ubuntu1
sudo apt-mark hold cuda cuda-drivers cuda-toolkit-config-common nvidia-modprobe nvidia-settings

#create symbolic link for cublas (for gazr)
# sudo ln -s /usr/lib/x86_64-linux-gnu/libcublas.so /usr/local/cuda-11.4/lib64/libcublas.so
if ! grep -Fxq "## CUDA and cuDNN paths" ~/.bashrc
then
    echo -e "\n## CUDA and cuDNN paths"  >> ~/.bashrc
    echo 'export PATH=/usr/local/cuda-11.4/bin:${PATH}' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.4/lib64:${LD_LIBRARY_PATH}' >> ~/.bashrc
    source ~/.bashrc # reload .bashrc with cuda path
fi
