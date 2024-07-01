#!/bin/bash
### Reference: https://github.com/juancarlosmiranda/azure_kinect_notes
### sudo rm /etc/apt/trusted.gpg.d/microsoft.gpg

# curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
# sudo apt-add-repository "deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/ubuntu/18.04/prod focal main"
# echo 'libk4a1.4 libk4a1.4/accepted-eula-hash string 0f5d5c5de396e4fee4c0753a21fee0c1ed726cf0316204edda484f08cb266d76' | sudo debconf-set-selections
# echo 'libk4a1.4 libk4a1.4/accept-eula boolean true' | sudo debconf-set-selections
# sudo apt update && sudo apt -y install libk4a1.4 libk4a1.4-dev k4a-tools

# Reference: https://github.com/microsoft/Azure-Kinect-Sensor-SDK/issues/1190
export ARG DEBIAN_FRONTEND=noninteractive
sudo apt install -y libgl1 libxrandr2 libxinerama1 libxcursor1 libsoundio1
mkdir -p ~/lib/azure_kinect/
curl -sSL https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4a1.3/libk4a1.3_1.3.0_amd64.deb > ~/lib/azure_kinect/libk4a1.3_1.3.0_amd64.deb
curl -sSL https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4a1.3-dev/libk4a1.3-dev_1.3.0_amd64.deb > ~/lib/azure_kinect/libk4a1.3-dev_1.3.0_amd64.deb
curl -sSL https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4abt1.0/libk4abt1.0_1.0.0_amd64.deb > ~/lib/azure_kinect/libk4abt1.0_1.0.0_amd64.deb
curl -sSL https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4abt1.0-dev/libk4abt1.0-dev_1.0.0_amd64.deb > ~/lib/azure_kinect/libk4abt1.0-dev_1.0.0_amd64.deb
curl -sSL https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/k/k4a-tools/k4a-tools_1.3.0_amd64.deb > ~/lib/azure_kinect/k4a-tools_1.3.0_amd64.deb
sudo echo 'libk4a1.3 libk4a1.3/accepted-eula-hash string 0f5d5c5de396e4fee4c0753a21fee0c1ed726cf0316204edda484f08cb266d76' | debconf-set-selections
sudo echo 'libk4abt1.0	libk4abt1.0/accepted-eula-hash	string	03a13b63730639eeb6626d24fd45cf25131ee8e8e0df3f1b63f552269b176e38' | debconf-set-selections
sudo dpkg -i ~/lib/azure_kinect/libk4a1.3_1.3.0_amd64.deb
sudo dpkg -i ~/lib/azure_kinect/libk4a1.3-dev_1.3.0_amd64.deb
sudo dpkg -i ~/lib/azure_kinect/libk4abt1.0_1.0.0_amd64.deb
sudo dpkg -i ~/lib/azure_kinect/libk4abt1.0-dev_1.0.0_amd64.deb
sudo dpkg -i ~/lib/azure_kinect/k4a-tools_1.3.0_amd64.deb
