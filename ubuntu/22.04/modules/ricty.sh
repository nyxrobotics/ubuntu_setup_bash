#!/bin/bash

# >>>ricty
# install fontforge
mkdir -p ~/.local/share/fonts/ricty/TrueType/Ricty
mkdir -p ~/.local/share/fonts/ricty/TrueType/RictyDiscord
temporary_directory=$(mktemp -d)
trap 'rm -rf "$temporary_directory"' EXIT
cd "$temporary_directory"
sudo apt install -y fontforge font-manager
# Download Inconsolata
wget -O Inconsolata.otf http://levien.com/type/myfonts/Inconsolata.otf
# Download Migu
if wget -O migu-1m-20150712.zip https://osdn.jp/projects/mix-mplus-ipa/downloads/63545/migu-1m-20150712.zip; then
  unzip migu-1m-20150712.zip
  mv migu-1m-20150712/migu-1m-regular.ttf .
  mv migu-1m-20150712/migu-1m-bold.ttf .
  rm -r migu-1m-20150712
else
  wget https://github.com/chrissimpkins/codeface/raw/master/cjk-fonts/migu1m/migu-1m-regular.ttf
  wget https://github.com/chrissimpkins/codeface/raw/master/cjk-fonts/migu1m/migu-1m-bold.ttf
fi
# clone Ricty
git clone https://github.com/metalefty/Ricty.git
# generate & install Ricty
#bash ricty_generator.sh auto
bash Ricty/ricty_generator.sh Inconsolata.otf migu-1m-regular.ttf migu-1m-bold.ttf
cp -f RictyDiscord*.ttf ~/.local/share/fonts/ricty/TrueType/RictyDiscord
cp -f Ricty*.ttf ~/.local/share/fonts/ricty/TrueType/Ricty
fc-cache -vf
