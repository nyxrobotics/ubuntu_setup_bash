#!/bin/bash

export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb
sudo apt update
sudo apt install -y python3-flake8-docstrings python3-pip python3-pytest-cov ros-dev-tools \
   python3-flake8-blind-except python3-flake8-builtins python3-flake8-class-newline python3-flake8-comprehensions \
   python3-flake8-deprecated python3-flake8-import-order python3-flake8-quotes python3-pytest-repeat python3-pytest-rerunfailures

mkdir -p ~/ros2_humble/src;cd ~/ros2_humble
vcs import --input https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos src
sudo rosdep init
rosdep update
rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"
if ! grep -Fxq "## ROS2 Humble paths" ~/.bashrc
then
    echo -e "\n## ROS2 Humble paths"  >> ~/.bashrc
    echo 'export ROS_DISTRO=humble' >> ~/.bashrc
    echo 'export RMW_IMPLEMENTATION=rmw_fastrtps_cpp' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/nyx/anaconda3/envs/env_isaaclab/lib/python3.11/site-packages/isaacsim/exts/isaacsim.ros2.bridge/humble/lib' >> ~/.bashrc
    source ~/.bashrc # reload .bashrc with cuda path
fi