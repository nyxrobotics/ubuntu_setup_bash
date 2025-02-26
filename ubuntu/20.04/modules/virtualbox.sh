#!/bin/bash

## Install virtualbox
mkdir -p ~/lib/virtualbox
cd ~/lib/virtualbox
wget https://download.virtualbox.org/virtualbox/7.1.4/virtualbox-7.1_7.1.4-165100~Ubuntu~focal_amd64.deb
sudo dpkg -i virtualbox-7.1_7.1.4-165100~Ubuntu~focal_amd64.deb

## Create symblic links
## Reference: https://www.virtualbox.org/ticket/22193

# sudo checkinstall --fstrans=no -yD --pkgname=virtualbox-symbolic-links --pkgversion=1 bash -c "ln -s /usr/lib/virtualbox/libdl.so /usr/lib/libdl.so.2; ln -s /usr/lib/virtualbox/libpthread.so /usr/lib/libpthread.so.0;"
# sudo dpkg -i virtualbox-symbolic-links_1-1_amd64.deb
