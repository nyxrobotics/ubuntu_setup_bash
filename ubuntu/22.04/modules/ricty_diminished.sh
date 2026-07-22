#!/bin/bash

# >>>ricty
# install fontforge
sudo apt install -y fontforge font-manager
mkdir -p ~/.local/share/fonts/ricty/TrueType/RictyDiminished
mkdir -p ~/.local/share/fonts/ricty/TrueType/RictyDiminishedDiscord
temporary_directory=$(mktemp -d)
trap 'rm -rf "$temporary_directory"' EXIT
cd "$temporary_directory"
git clone https://github.com/edihbrandon/RictyDiminished.git
cp -f RictyDiminished/RictyDiminishedDiscord*.ttf ~/.local/share/fonts/ricty/TrueType/RictyDiminishedDiscord
cp -f RictyDiminished/RictyDiminished*.ttf ~/.local/share/fonts/ricty/TrueType/RictyDiminished
fc-cache -vf
