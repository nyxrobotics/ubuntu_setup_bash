#!/bin/bash

# >>>ricty
# install fontforge
mkdir -p ricty_tmp
cd ricty_tmp
sudo apt install -y fontforge
mkdir -p ~/lib/.fonts
# install Inconsolata
wget http://levien.com/type/myfonts/Inconsolata.otf
cp Inconsolata.otf ~/lib/.fonts
# install Migu
wget https://osdn.jp/projects/mix-mplus-ipa/downloads/63545/migu-1m-20150712.zip
unzip migu-1m-20150712.zip
cp migu-1m-20150712/*.ttf ~/lib/.fonts
# clone Ricty
git clone https://github.com/metalefty/Ricty.git
# generate & install Ricty
cd Ricty
#bash ricty_generator.sh auto
bash ricty_generator.sh ~/lib/.fonts/Inconsolata.otf ~/lib/.fonts/migu-1m-regular.ttf ~/lib/.fonts/migu-1m-bold.ttf
cp -f Ricty*.ttf ~/.fonts
fc-cache -vf
cd ../..
sudo rm -r ricty_tmp
