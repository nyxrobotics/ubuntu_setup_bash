#!/bin/bash

sudo apt install libpyside2-dev python3-opengl cmake libglu1-mesa-dev freeglut3-dev mesa-common-dev checkinstall

echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys D2486D2DD83DB69272AFE98867170598AF249743
sudo apt update;sudo apt install gazebo

mkdir -p ~/program_files/usd
export USD_PATH=~/program_files/usd
mkdir -p ~/program_files/gz-cmake
export GZ_CMAKE_PATH=~/program_files/gz-cmake

mkdir -p ~/lib/gz_usd

# Install sdf
cd ~/lib/gz_usd
git clone --depth 1 -b sdf14 --single-branch git@github.com:gazebosim/sdformat.git
cd sdformat
sudo apt -y install $(sort -u $(find . -iname 'packages-'`lsb_release -cs`'.apt' -o -iname 'packages.apt' | tr '\n' ' '))

# Install OpenUSD
cd ~/lib/gz_usd
git clone --depth 1 --single-branch https://github.com/PixarAnimationStudios/OpenUSD.git
cd OpenUSD
git fetch --tags origin v24.08
git switch -c v24.08 tags/v24.08
python3 build_scripts/build_usd.py --build-variant release --no-tests --no-examples --no-imaging --onetbb --no-tutorials --no-docs --no-python $USD_PATH

# Install gz-cmake
cd ~/lib/gz_usd
git clone --depth 1 --single-branch git@github.com:gazebosim/gz-cmake.git
cd gz-cmake
git fetch --tags origin gz-cmake3_3.5.5
git switch -c gz-cmake3_3.5.5 tags/gz-cmake3_3.5.5
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$GZ_CMAKE_PATH
make
sudo checkinstall --pkgname=gz-cmake --pkgversion=3.5.5 -y

# Install gz-usd
cd ~/lib/gz_usd
git clone --depth 1 -b fortress --single-branch git@github.com:gazebosim/gz-usd.git
cd gz-usd
mkdir build
cd build
export GZ_VERSION=fortress
cmake .. -DCMAKE_PREFIX_PATH="$GZ_CMAKE_PATH/share/cmake/gz-cmake3;$USD_PATH"
make
sudo checkinstall --pkgname=gz-usd --pkgversion=0fortress -y

# Add path
if ! grep -Fxq "## gz_usd paths" ~/.bashrc
then
    echo -e "\n## gz_usd paths"  >> ~/.bashrc
    echo 'export PATH=$USD_PATH/bin:$PATH' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=$USD_PATH/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
    echo 'export CMAKE_PREFIX_PATH=$USD_PATH:$CMAKE_PREFIX_PATH' >> ~/.bashrc
    source ~/.bashrc
fi