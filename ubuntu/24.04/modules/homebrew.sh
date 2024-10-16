#!/bin/bash

### Reference: https://qiita.com/yamatai12/items/a74b68bbe60e1ed8bc2d
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
sudo checkinstall --fstrans=no -yD --install=no --pkgname=homebrew --pkgversion=0.0.0 sudo -u $USER bash -c "NONINTERACTIVE=1 $SCRIPT_DIR/homebrew/install_homebrew.sh"
sudo dpkg -i homebrew_0.0.0-1_amd64.deb
sudo rm homebrew_0.0.0-1_amd64.deb

if ! grep -Fxq "## Enable homebrew" ~/.bashrc
then
	HOMEBREW_BIN_PATH=${HOME}/.linuxbrew/bin
    echo -e "\n## Enable homebrew"  >> ~/.bashrc
    echo 'export PATH='$HOMEBREW_BIN_PATH':${PATH}' >> ~/.bashrc
    source ~/.bashrc # reload .bashrc with homebrew path
fi
