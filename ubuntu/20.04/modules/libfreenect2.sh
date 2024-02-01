#!/bin/bash
# Reference: https://www.notaboutmy.life/posts/run-kinect-2-on-ubuntu-20-lts/

sudo apt install git checkinstall build-essential cmake pkg-config libusb-1.0-0-dev libturbojpeg0-dev libglfw3-dev libva-dev libjpeg-dev libopenni2-dev -y
mkdir -p ~/lib
cd ~/lib
LIBDIR=$(pwd -P)
git clone https://github.com/OpenKinect/libfreenect2.git
cd libfreenect2
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local
make
sudo checkinstall --install=no --fstrans=no -yD --pkgname=libfreenect2_udev --pkgversion=1.0 cp ${LIBDIR}/libfreenect2/platform/linux/udev/90-kinect2.rules /etc/udev/rules.d/
sudo checkinstall --install=no --fstrans=no -yD --pkgname=libfreenect2 --pkgversion=1.0
sudo dpkg -i libfreenect2-udev_1.0-1_amd64.deb
sudo dpkg -i libfreenect2_1.0-1_amd64.deb

