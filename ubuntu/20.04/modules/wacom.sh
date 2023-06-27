#!/bin/bash

### input-wacom
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

### xf86-input-wacom
cd ~/lib/
git clone git@github.com:linuxwacom/xf86-input-wacom.git
cd xf86-input-wacom
sudo sh -c "apt-get update && apt-get install xserver-xorg-input-wacom$(dpkg -S $(which Xorg) | grep -Eo -- "-hwe-[^:]*")"
sudo apt install -y autoconf pkg-config make xutils-dev libtool xserver-xorg-dev$(dpkg -S $(which Xorg) | grep -Eo -- "-hwe-[^:]*") libx11-dev libxi-dev libxrandr-dev libxinerama-dev libudev-dev

set -- --prefix="/usr" --libdir="$(readlink -e $(ls -d /usr/lib*/xorg/modules/input/../../../ | head -n1))"
if test -x ./autogen.sh;
    then ./autogen.sh "$@";
else
    ./configure "$@";
fi
make
sudo checkinstall -yD --pkgname=xf86-input-wacom --pkgversion=1
sudo dpkg -i xf86-input-wacom_1-1_amd64.deb

### libwacom
sudo apt install -y meson valgrind python3-pytest
pip3 install libevdev pyudev pytest 
cd ~/lib
git clone git@github.com:linuxwacom/libwacom.git
cd libwacom
meson compile
sudo checkinstall -yD --pkgname=libwacom --pkgversion=1 ninja -C build install
sudo dpkg -i libwacom_1-1_amd64.deb
