#!/bin/bash

# install latest i915 drivers (they are too old in ubuntu16.04)
mkdir -p ~/lib
cd ~/lib
git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
sudo cp linux-firmware/i915/*.bin /lib/firmware/i915/
sudo update-initramfs -u
