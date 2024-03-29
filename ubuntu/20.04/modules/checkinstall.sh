#!/bin/bash

sudo apt install -y checkinstall
mkdir -p ~/lib
cd ~/lib
git clone git@github.com:giuliomoro/checkinstall.git
cd checkinstall
./configure
make
sudo checkinstall -yD --pkgname=checkinstall --pkgversion=1.6.3
sudo apt purge -y checkinstall
sudo apt autoremove -y
sudo dpkg -i checkinstall_1.6.3-1_amd64.deb
