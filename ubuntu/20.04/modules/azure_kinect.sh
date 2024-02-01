#!/bin/bash
# Reference: https://github.com/juancarlosmiranda/azure_kinect_notes
# sudo rm /etc/apt/trusted.gpg.d/microsoft.gpg
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/ubuntu/18.04/prod focal main"
echo 'libk4a1.4 libk4a1.4/accepted-eula-hash string 0f5d5c5de396e4fee4c0753a21fee0c1ed726cf0316204edda484f08cb266d76' | sudo debconf-set-selections
echo 'libk4a1.4 libk4a1.4/accept-eula boolean true' | sudo debconf-set-selections
sudo apt update && sudo apt -y install libk4a1.4 libk4a1.4-dev k4a-tools
