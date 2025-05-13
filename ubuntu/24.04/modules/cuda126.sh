#!/bin/bash

alias cc="gcc-12"

sudo apt-mark unhold \
cuda \
cuda-drivers \
cuda-drivers-560 \
cuda-toolkit-config-common \
nvidia-modprobe \
nvidia-settings \
libxnvctrl0 \
cuda-toolkit-11-config-common

sudo apt purge ~nnvidia

#sudo aptitude purge ~ncuda
sudo apt purge -y -f "libxnvctrl0" "*cuda*" "*cudnn*" "*nvidia*" "*nsight*" "libcublas*" "*libcudnn*"

sudo apt autoremove -y
sudo apt clean -y

mkdir -p ~/lib/nvidia
cd ~/lib/nvidia

if [ -f "cuda-keyring_1.1-1_all.deb" ]; then
    echo "cuda-keyring_1.1-1_all.deb exists."
else
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
fi

sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt update

sudo apt install -y --allow-downgrades \
cuda-12-6=12.6.3-1 \
cuda-command-line-tools-12-6=12.6.3-1 \
cuda-cupti-12-6=12.6.80-1 \
cuda-cupti-dev-12-6=12.6.80-1 \
cuda-demo-suite-12-6=12.6.77-1 \
cuda-documentation-12-6=12.6.77-1 \
cuda-gdb-12-6=12.6.77-1 \
cuda-libraries-12-6=12.6.3-1 \
cuda-libraries-dev-12-6=12.6.3-1 \
cuda-nsight-12-6=12.6.77-1 \
cuda-nsight-compute-12-6=12.6.3-1 \
cuda-nsight-systems-12-6=12.6.3-1 \
cuda-nvdisasm-12-6=12.6.77-1 \
cuda-nvml-dev-12-6=12.6.77-1 \
cuda-nvprof-12-6=12.6.80-1 \
cuda-nvrtc-dev-12-6=12.6.85-1 \
cuda-nvtx-12-6=12.6.77-1 \
cuda-nvvp-12-6=12.6.80-1 \
cuda-opencl-12-6=12.6.77-1 \
cuda-opencl-dev-12-6=12.6.77-1 \
cuda-profiler-api-12-6=12.6.77-1 \
cuda-runtime-12-6=12.6.3-1 \
cuda-sanitizer-12-6=12.6.77-1 \
cuda-toolkit-12-6=12.6.3-1 \
cuda-toolkit-12-config-common=12.9.37-1 \
cuda-toolkit-config-common=12.9.37-1 \
cuda-tools-12-6=12.6.3-1 \
cuda-visual-tools-12-6=12.6.3-1 \
gds-tools-12-6=1.11.1.6-1 \
libcublas-12-6=12.6.4.1-1 \
libcublas-dev-12-6=12.6.4.1-1 \
libcufft-12-6=11.3.0.4-1 \
libcufft-dev-12-6=11.3.0.4-1 \
libcufile-12-6=1.11.1.6-1 \
libcufile-dev-12-6=1.11.1.6-1 \
libcurand-12-6=10.3.7.77-1 \
libcurand-dev-12-6=10.3.7.77-1 \
libcusolver-12-6=11.7.1.2-1 \
libcusolver-dev-12-6=11.7.1.2-1 \
libcusparse-12-6=12.5.4.2-1 \
libcusparse-dev-12-6=12.5.4.2-1 \
libnpp-12-6=12.3.1.54-1 \
libnpp-dev-12-6=12.3.1.54-1 \
libnvfatbin-12-6=12.6.77-1 \
libnvfatbin-dev-12-6=12.6.77-1 \
libnvidia-cfg1-560=560.35.05-0ubuntu1 \
libnvidia-common-560=560.35.05-0ubuntu1 \
libnvidia-compute-560=560.35.05-0ubuntu1 \
libnvidia-decode-560=560.35.05-0ubuntu1 \
libnvidia-encode-560=560.35.05-0ubuntu1 \
libnvidia-extra-560=560.35.05-0ubuntu1 \
libnvidia-fbc1-560=560.35.05-0ubuntu1 \
libnvidia-gl-560=560.35.05-0ubuntu1 \
libnvjitlink-12-6=12.6.85-1 \
libnvjitlink-dev-12-6=12.6.85-1 \
libnvjpeg-12-6=12.3.3.54-1 \
libnvjpeg-dev-12-6=12.3.3.54-1 \
libxcb-cursor0=0.1.4-1build1 \
nsight-compute-2024.3.2=2024.3.2.3-1 \
nsight-systems-2024.5.1=2024.5.1.113-245134619542v0 \
nvidia-compute-utils-560=560.35.05-0ubuntu1 \
nvidia-dkms-560-open=560.35.05-0ubuntu1 \
nvidia-driver-560-open=560.35.05-0ubuntu1 \
nvidia-firmware-560-560.35.05=560.35.05-0ubuntu1 \
nvidia-kernel-common-560=560.35.05-0ubuntu1 \
nvidia-kernel-source-560-open=560.35.05-0ubuntu1 \
nvidia-modprobe=575.51.03-0ubuntu1 \
nvidia-open=560.35.05-0ubuntu1 \
nvidia-open-560=560.35.05-0ubuntu1 \
nvidia-utils-560=560.35.05-0ubuntu1 \
xserver-xorg-video-nvidia-560=560.35.05-0ubuntu1 

sudo apt-mark hold \
cuda \
cuda-drivers \
cuda-drivers-560 \
cuda-toolkit-config-common \
cuda-toolkit-11-config-common \
libnvidia-cfg1-560 \
libnvidia-common-560 \
libnvidia-compute-560 \
libnvidia-decode-560 \
libnvidia-encode-560 \
libnvidia-extra-560 \
libnvidia-fbc1-560 \
libnvidia-gl-560 \
nvidia-compute-utils-560 \
nvidia-dkms-560 \
nvidia-driver-560 \
nvidia-kernel-common-560 \
nvidia-kernel-source-560 \
nvidia-modprobe \
nvidia-settings \
nvidia-utils-560 \
xserver-xorg-video-nvidia-560 \
libxnvctrl0

if ! grep -Fxq "## CUDA and cuDNN paths" ~/.bashrc
then
    echo -e "\n## CUDA and cuDNN paths"  >> ~/.bashrc
    echo 'export PATH=/usr/local/cuda-11.8/bin:${PATH}' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:${LD_LIBRARY_PATH}' >> ~/.bashrc
    source ~/.bashrc # reload .bashrc with cuda path
fi
