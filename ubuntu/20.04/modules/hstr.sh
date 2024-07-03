#!/bin/bash

### HSTR
### Reference: https://unix.stackexchange.com/questions/209495/bash-incremental-history-search-ctrlr-matching-multiple-non-adjacent-word
wget -qO - https://www.mindforger.com/gpgpubkey.txt | sudo apt-key add -
# add PPA to APT sources:
echo "deb http://www.mindforger.com/debian-ppa/bookworm bookworm main" | sudo tee /etc/apt/sources.list.d/mindforger.list
sudo apt update
sudo apt install hstr

if ! grep -Fxq "# HSTR configuration - add this to ~/.bashrc" ~/.bashrc
then
    hstr --show-configuration >> ~/.bashrc
    source ~/.bashrc # reload .bashrc with cuda path
fi
