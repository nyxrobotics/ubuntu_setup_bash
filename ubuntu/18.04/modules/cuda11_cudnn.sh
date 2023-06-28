#!/bin/bash

sudo apt-mark unhold cuda-drivers
sudo apt purge -y --allow-change-held-packages "*cuda*" "*nvidia*" "*nsight*" "libcublas*"
sudo apt autoremove -y

mkdir -p ~/lib/nvidia
cd ~/lib/nvidia

if [ -f "cudnn-local-repo-ubuntu1804-8.4.1.50_1.0-1_amd64.deb" ]; then
    echo "cudnn-local-repo-ubuntu1804-8.4.1.50_1.0-1_amd64.deb exists."
else
    wget https://developer.nvidia.com/compute/cudnn/secure/8.4.1/local_installers/11.6/cudnn-local-repo-ubuntu1804-8.4.1.50_1.0-1_amd64.deb
fi

sudo dpkg -i cudnn-local-repo-ubuntu1804-8.4.1.50_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-ubuntu1804-8.4.1.50/cudnn-local-BA71F057-keyring.gpg /usr/share/keyrings/
sudo apt-key add /var/cuda-repo-ubuntu1804-11-4-local/7fa2af80.pub
sudo apt-key add /var/cuda-repo-ubuntu2004-11-4-local/3bf863cc.pub
sudo apt update
sudo apt --only-upgrade install cudnn-local-repo-ubuntu1804-8.4.1.50
sudo apt install -y libcudnn8 libcudnn8-dev libcudnn8-samples
