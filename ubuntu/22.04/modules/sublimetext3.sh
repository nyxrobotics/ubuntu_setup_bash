#!/bin/bash

# >>>sublime text3
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null
echo -e 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc' | sudo tee /etc/apt/sources.list.d/sublime-text.sources
sudo apt update
sudo apt install -y sublime-text

# >> copy config (popup block)
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
cp -r $SCRIPT_DIR/../config/sublime-text-3 ~/.config/
