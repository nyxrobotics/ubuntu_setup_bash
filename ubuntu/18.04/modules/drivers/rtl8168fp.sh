#!/bin/bash

# install latest rtl8125a-3 drivers (they are too old in ubuntu18.04)
mkdir -p ~/lib
cd ~/lib
git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
sudo cp ./linux-firmware/rtl_nic/* /lib/firmware/rtl_nic/
sudo update-initramfs -u
