#!/bin/bash

sudo apt-mark unhold cuda-drivers
#sudo aptitude purge ~ncuda
sudo apt purge -y --allow-change-held-packages "*cuda*" "*nvidia*" "*nsight*"
sudo apt autoremove -y

mkdir -p ~/lib/nvidia
cd ~/lib/nvidia

if [ -f "cuda-repo-ubuntu1604-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb" ]; then
    echo "cuda-repo-ubuntu1604-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb exists."
else
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-ubuntu1604.pin
	sudo mv cuda-ubuntu1604.pin /etc/apt/preferences.d/cuda-repository-pin-600
    wget https://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1604-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
fi

sudo dpkg -i cuda-repo-ubuntu1604-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
sudo apt update
sudo apt --only-upgrade install cuda-repo-ubuntu1604-10-2-local-10.2.89-440.33.01
sudo apt install -y cuda-drivers cuda-10-2 nvidia-opencl-dev
sudo apt-mark hold cuda-drivers
#create symbolic link for cublas (for gazr)
sudo ln -s /usr/lib/x86_64-linux-gnu/libcublas.so /usr/local/cuda-10.2/lib64/libcublas.so
if ! grep -Fxq "## CUDA and cuDNN paths" ~/.bashrc
then
    echo -e "\n## CUDA and cuDNN paths"  >> ~/.bashrc
    echo 'export PATH=/usr/local/cuda-10.2/bin:${PATH}' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64:${LD_LIBRARY_PATH}' >> ~/.bashrc
    source ~/.bashrc # reload .bashrc with cuda path
fi
