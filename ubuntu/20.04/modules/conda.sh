#!/bin/bash

sudo apt install -y fontforge font-manager
mkdir -p ~/lib/anaconda
cd ~/lib/anaconda
wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh
sudo checkinstall --install=no --fstrans=no -yD --pkgname=anaconda --pkgversion=1 bash -c "bash /home/nyx/lib/isaaclab/Anaconda3-2022.05-Linux-x86_64.sh"
