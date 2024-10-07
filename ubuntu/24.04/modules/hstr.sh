#!/bin/bash

### HSTR
### Reference: https://unix.stackexchange.com/questions/209495/bash-incremental-history-search-ctrlr-matching-multiple-non-adjacent-word
# add PPA to APT sources:
sudo add-apt-repository ppa:ultradvorka/ppa
sudo apt update
sudo apt install hstr

if ! grep -Fxq "# HSTR configuration - add this to ~/.bashrc" ~/.bashrc
then
    hstr --show-configuration >> ~/.bashrc
    source ~/.bashrc # reload .bashrc with cuda path
fi
