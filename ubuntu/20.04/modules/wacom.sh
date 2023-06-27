#!/bin/bash

sudo apt install build-essential autoconf
mkdir -p ~/lib/
cd ~/lib/
git clone git@github.com:linuxwacom/input-wacom.git
cd  input-wacom
if test -x ./autogen.sh; then
    ./autogen.sh;
else
    ./configure;
fi
make
sudo checkinstall -yD --pkgname=input-wacom --pkgversion=1
sudo dpkg -i input-wacom_1-1_amd64.deb
