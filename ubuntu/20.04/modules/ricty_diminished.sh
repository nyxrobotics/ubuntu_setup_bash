#!/bin/bash

# >>>ricty
# install fontforge
sudo apt install -y fontforge font-manager
mkdir -p ricty_tmp
mkdir -p ~/.local/share/fonts/ricty/TrueType/RictyDiminished
mkdir -p ~/.local/share/fonts/ricty/TrueType/RictyDiminishedDiscord
cd ricty_tmp
git clone git@github.com:edihbrandon/RictyDiminished.git
cp -f RictyDiminished/RictyDiminishedDiscord*.ttf ~/.local/share/fonts/ricty/TrueType/RictyDiminishedDiscord
cp -f RictyDiminished/RictyDiminished*.ttf ~/.local/share/fonts/ricty/TrueType/RictyDiminished
fc-cache -vf
cd ..
sudo rm -r ricty_tmp
