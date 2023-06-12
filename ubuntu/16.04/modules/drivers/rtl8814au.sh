#!/bin/bash

# >>>install packages
sudo apt install -y git build-essential dkms checkinstall
mkdir -p ~/lib
cd ~/lib
git clone https://github.com/zebulon2/rtl8814au.git
cd rtl8814au
make -j8
sudo checkinstall --pkgname=rtl8814au --default
