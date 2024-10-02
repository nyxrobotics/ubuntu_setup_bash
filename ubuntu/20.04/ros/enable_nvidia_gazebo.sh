#!/bin/bash
if ! grep -Fxq "## Use Nvidia rendering for Gazebo" ~/.bashrc
then
    echo -e "\n## Use Nvidia rendering for Gazebo"  >> ~/.bashrc
    echo 'export __NV_PRIME_RENDER_OFFLOAD=1' >> ~/.bashrc
    echo 'export __GLX_VENDOR_LIBRARY_NAME=nvidia' >> ~/.bashrc
fi
source ~/.bashrc # reload .bashrc
