#!/bin/bash
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

sudo apt install -y checkinstall gettext
mkdir -p ~/lib
cd ~/lib
git clone git@github.com:giuliomoro/checkinstall.git
cd checkinstall

# Reference: https://bbs.archlinux.org/viewtopic.php?id=265659
patch -p1 < $SCRIPT_DIR/fix-checkinstall.patch

./configure
make
sudo checkinstall -yD --install=no --pkgname=checkinstall --pkgversion=1.6.3
sudo apt purge -y checkinstall
sudo apt autoremove -y
sudo dpkg -i checkinstall_1.6.3-1_amd64.deb
