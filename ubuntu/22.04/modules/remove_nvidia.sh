#!/bin/bash

#sudo aptitude purge ~ncuda
sudo apt purge -y --allow-change-held-packages \
"libxnvctrl0" "*cuda*" "*cudnn*" "*nvidia*" "*nsight*" "libcublas*"

sudo apt autoremove -y
sudo apt clean -y
sudo apt update
sudo apt install -f
sudo dpkg --configure -a
