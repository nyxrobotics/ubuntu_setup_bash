#!/bin/bash
#See here -> https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi

# >>> Install from source
# mkdir -p ~/lib
# cd ~/lib
# git clone --single-branch --branch release/core54 https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/backport-iwlwifi.git
# cd backport-iwlwifi
# make defconfig-iwlwifi-public
# sed -i 's/CPTCFG_IWLMVM_VENDOR_CMDS=y/# CPTCFG_IWLMVM_VENDOR_CMDS is not set/' .config
# make -j4
# sudo checkinstall --pkgname=iwlwifi --pkgversion=54 --default

# >>> Install from apt
sudo add-apt-repository -y ppa:canonical-hwe-team/backport-iwlwifi
sudo apt update
sudo apt install backport-iwlwifi-dkms 
