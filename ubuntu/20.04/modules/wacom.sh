#!/bin/bash

### input-wacom
sudo apt install -y build-essential autoconf libgudev-1.0-dev libevdev-dev libglib2.0-dev
mkdir -p ~/lib/
cd ~/lib/
git clone git@github.com:linuxwacom/input-wacom.git
cd  input-wacom
git checkout for-5.15
if test -x ./autogen.sh; then
    ./autogen.sh;
else
    ./configure;
fi
make
sudo checkinstall -yD --pkgname=input-wacom --pkgversion=5.15
sudo dpkg -i input-wacom_5.15-1_amd64.deb

### xf86-input-wacom
cd ~/lib/
git clone git@github.com:linuxwacom/xf86-input-wacom.git
cd xf86-input-wacom
sudo sh -c "apt-get update && apt-get install xserver-xorg-input-wacom$(dpkg -S $(which Xorg) | grep -Eo -- "-hwe-[^:]*")"
sudo apt install -y autoconf pkg-config make xutils-dev libtool xserver-xorg-dev$(dpkg -S $(which Xorg) | grep -Eo -- "-hwe-[^:]*") libx11-dev libxi-dev libxrandr-dev libxinerama-dev libudev-dev

set -- --prefix="/usr" --libdir="$(readlink -e $(ls -d /usr/lib*/xorg/modules/input/../../../ | head -n1))"
if test -x ./autogen.sh; then ./autogen.sh "$@"; else ./configure "$@"; fi && make || echo "Build Failed"
sudo checkinstall -yD --pkgname=xf86-input-wacom --pkgversion=1
sudo dpkg -i xf86-input-wacom_1-1_amd64.deb

### libwacom
sudo apt install -y meson valgrind python3-pytest doxygen
pip3 install libevdev pyudev pytest 
cd ~/lib
git clone git@github.com:linuxwacom/libwacom.git
cd libwacom
git checkout -b 1.9 libwacom-1.9
meson build
ninja -C ./build
sudo checkinstall --fstrans=no -yD --pkgname=libwacom --pkgversion=1.9 bash -c "mkdir -p /usr/local/share/libwacom/layouts; ninja -C ./build install"
sudo dpkg -i libwacom_1.9-1_amd64.deb
