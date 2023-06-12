#!/bin/bash

mkdir -p ~/lib
cd ~/lib
echo "options ath10k_core skip_otp=Y" | sudo tee /etc/modprobe.d/ath10k_core.conf
sudo rm -r /lib/firmware/ath10k/QCA6174/
git clone https://github.com/FireWalkerX/ath10k-firmware.git
sudo cp -r ath10k-firmware/QCA6174/ /lib/firmware/ath10k/
sudo update-initramfs -u
# Disable Powersave
sudo sed -i 's/wifi.powersave = 3/wifi.powersave = 2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
