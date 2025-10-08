#!/bin/bash

## Reference: https://linuxcapable.com/how-to-install-sublime-text-on-ubuntu-linux/

# >>>sublime text3
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fSsL https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/sublimehq-pub.gpg > /dev/null
echo 'deb [signed-by=/usr/share/keyrings/sublimehq-pub.gpg] https://download.sublimetext.com/ apt/stable/' | sudo tee -a /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt install -y sublime-text

# >> copy config (popup block)
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
cp -r $SCRIPT_DIR/../config/sublime-text-3 ~/.config/
