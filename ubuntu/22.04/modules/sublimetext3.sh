#!/bin/bash

# >>>sublime text3
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo add-apt-repository -y "deb https://download.sublimetext.com/ apt/stable/"
sudo apt update
sudo apt install -y sublime-text

# >> copy config (popup block)
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
cp -r $SCRIPT_DIR/../config/sublime-text-3 ~/.config/
