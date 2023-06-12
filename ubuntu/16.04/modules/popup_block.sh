#!/bin/bash

# >>>Disable automatic package update
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
cd $SCRIPT_DIR
sudo apt install -y unattended-upgrades
sudo cp ../config/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades
sudo /etc/init.d/unattended-upgrades restart
# >>>disable update-notifier (GUI popup)
sudo cp ../config/10periodic /etc/apt/apt.conf.d/10periodic
sudo cp ../config/99update-notifier /etc/apt/apt.conf.d/99update-notifier
# >> Disable automatic distribution update popup
gsettings set com.ubuntu.update-notifier no-show-notifications true
sudo sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades
# >>>Install NoNotifs
sudo add-apt-repository -y ppa:vlijm/nonotifs
sudo apt update && sudo apt install nonotifs
# >> set Startup
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
cp -r $SCRIPT_DIR/../config/nonotifs_prefs ~/.config/
mkdir -p ~/.config/autostart
cp $SCRIPT_DIR/../config/autostart_nonotifs.desktop ~/.config/autostart
