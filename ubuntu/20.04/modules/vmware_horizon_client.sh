#!/bin/bash

mkdir -p ~/lib/vmware_horizon_client
cd ~/lib/vmware_horizon_client
wget https://download3.vmware.com/software/CART24FQ2_LIN64_DebPkg_2306/VMware-Horizon-Client-2306-8.10.0-21964631.x64.deb
sudo dpkg -i --force-all VMware-Horizon-Client-2306-8.10.0-21964631.x64.deb
