#!/bin/bash

# Fix "W: Possible missing firmware /lib/firmware/ast_dp501_fw.bin for module ast" error
# Reference: https://serverfault.com/questions/755194/ubuntu-15-10-server-w-possible-missing-firmware-lib-firmware-ast-dp501-fw-bin/762511
# Download URL: https://www.supermicro.com/support/faqs/faq.cfm?faq=26876

# >>>download driver for supermicro's motherboards
mkdir -p ~/lib/supermicro
cd ~/lib/supermicro
wget "https://drive.google.com/uc?export=download&id=1rBp3z_4_LNmx8ci_U4VAL5-qB4sjM-aV" -O ast_dp501_fw.bin
# >>>copy driver
sudo cp ast_dp501_fw.bin  /lib/firmware/ast_dp501_fw.bin
sudo update-initramfs -u
