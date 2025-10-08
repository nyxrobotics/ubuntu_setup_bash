#!/bin/bash

sudo apt install -y fontforge font-manager
mkdir -p ~/.local/share/fonts/YaHei/TrueType/consolas
mkdir -p consolas_tmp
cd consolas_tmp
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/uigroupcode/YaHei.Consolas.1.12.zip
unzip YaHei.Consolas.1.12.zip
mv YaHei.Consolas.1.12.ttf ~/.local/share/fonts/YaHei/TrueType/consolas

mkdir -p ~/.local/share/fonts/freefonts/TrueType/consolas
wget https://freefontsdownload.net/download/33098/consolas.zip
unzip consolas.zip
mv CONSOLA.TTF CONSOLAB.TTF Consolas.ttf consolaz.ttf consolai.ttf ~/.local/share/fonts/freefonts/TrueType/consolas
fc-cache -vf
cd ..
sudo rm -r consolas_tmp
