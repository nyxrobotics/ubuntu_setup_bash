#!/bin/bash

mkdir -p ~/lib/anaconda; cd ~/lib/anaconda
wget -O anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
bash anaconda.sh
export PATH="/home/$USER/anaconda3/bin:$PATH"
if ! grep -Fxq "## Conda paths" ~/.bashrc
then
    echo -e "\n## Conda paths"  >> ~/.bashrc
    echo 'export PATH="/home/$USER/anaconda3/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
fi
