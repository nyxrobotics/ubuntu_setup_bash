#!/bin/bash

mkdir -p ~/lib/vmware_horizon_client
cd ~/lib/vmware_horizon_client

wget -c http://archive.ubuntu.com/ubuntu/pool/universe/p/pygtk/python-gtk2_2.24.0-5.1ubuntu2_amd64.deb
wget -c http://archive.ubuntu.com/ubuntu/pool/universe/p/pygtk/python-gtk2-dev_2.24.0-5.1ubuntu2_all.deb
sudo apt install ./python-gtk2-dev_2.24.0-5.1ubuntu2_all.deb  ./python-gtk2_2.24.0-5.1ubuntu2_amd64.deb

sudo apt update
sudo apt install vpnc network-manager-vpnc network-manager-vpnc-gnome openvpn network-manager-openvpn network-manager-openvpn-gnome
sudo systemctl restart network-manager

wget https://download3.vmware.com/software/CART24FQ2_LIN64_DebPkg_2306/VMware-Horizon-Client-2306-8.10.0-21964631.x64.deb
sudo dpkg -i --force-all VMware-Horizon-Client-2306-8.10.0-21964631.x64.deb
