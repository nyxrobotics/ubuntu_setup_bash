#!/bin/bash

sudo apt-mark unhold cuda-drivers
#sudo aptitude purge ~ncuda
sudo apt purge -y --allow-change-held-packages "*cuda*" "*cudnn*" "*nvidia*" "*nsight*" "libcublas*"
sudo apt autoremove -y

mkdir -p ~/lib/nvidia
cd ~/lib/nvidia

if [ -f "cuda-repo-ubuntu1804-11-4-local_11.4.4-470.82.01-1_amd64.deb" ]; then
    echo "cuda-repo-ubuntu1804-11-4-local_11.4.4-470.82.01-1_amd64.deb exists."
else
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
    sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
    wget https://developer.download.nvidia.com/compute/cuda/11.4.4/local_installers/cuda-repo-ubuntu1804-11-4-local_11.4.4-470.82.01-1_amd64.deb
fi

sudo dpkg -i cuda-repo-ubuntu1804-11-4-local_11.4.4-470.82.01-1_amd64.deb
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb 
sudo apt update
sudo apt --only-upgrade install cuda-repo-ubuntu1804-11-4-local
sudo apt install -y cuda
#create symbolic link for cublas (for gazr)
# sudo ln -s /usr/lib/x86_64-linux-gnu/libcublas.so /usr/local/cuda-11.4/lib64/libcublas.so
if ! grep -Fxq "## CUDA and cuDNN paths" ~/.bashrc
then
    echo -e "\n## CUDA and cuDNN paths"  >> ~/.bashrc
    echo 'export PATH=/usr/local/cuda-11.4/bin:${PATH}' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.4/lib64:${LD_LIBRARY_PATH}' >> ~/.bashrc
    source ~/.bashrc # reload .bashrc with cuda path
fi
