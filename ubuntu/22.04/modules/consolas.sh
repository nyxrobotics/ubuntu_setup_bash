#!/bin/bash

sudo apt install -y fontforge font-manager
mkdir -p ~/.local/share/fonts/YaHei/TrueType/consolas
temporary_directory=$(mktemp -d)
trap 'rm -rf "$temporary_directory"' EXIT
cd "$temporary_directory"
wget -O YaHei.Consolas.1.12.zip https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/uigroupcode/YaHei.Consolas.1.12.zip
unzip YaHei.Consolas.1.12.zip
install -m 0644 YaHei.Consolas.1.12.ttf ~/.local/share/fonts/YaHei/TrueType/consolas/

mkdir -p ~/.local/share/fonts/freefonts/TrueType/consolas
wget -O consolas.zip https://freefontsdownload.net/download/33098/consolas.zip
unzip consolas.zip
install -m 0644 CONSOLA.TTF CONSOLAB.TTF Consolas.ttf consolaz.ttf consolai.ttf ~/.local/share/fonts/freefonts/TrueType/consolas/
fc-cache -vf
