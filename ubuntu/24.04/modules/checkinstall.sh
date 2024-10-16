#!/bin/bash

sudo apt install -y checkinstall gettext
mkdir -p ~/lib
cd ~/lib
git clone -b feature/ubuntu24.04 git@github.com:nyxrobotics/checkinstall.git
cd checkinstall
make
sudo checkinstall -yD --install=no --fstrans=no --pkgname=checkinstall --pkgversion=1.6.3 
sudo apt purge -y checkinstall
sudo apt autoremove -y
sudo dpkg -i checkinstall_1.6.3-1_amd64.deb
