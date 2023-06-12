#!/bin/bash

# >>>Disable automatic package update
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
cd $SCRIPT_DIR
sudo apt install -y unattended-upgrades
sudo cp ../config/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades
sudo /etc/init.d/unattended-upgrades restart
# >>>Disable update scheduler on Ubuntu 18.04
sudo systemctl disable apt-daily.service apt-daily-upgrade.service
sudo systemctl disable apt-daily.timer apt-daily-upgrade.timer
# >>>Disable update-notifier (GUI popup)
sudo cp ../config/10periodic /etc/apt/apt.conf.d/10periodic
sudo cp ../config/99update-notifier /etc/apt/apt.conf.d/99update-notifier
# >>>Disable distribution update popup
gsettings set com.ubuntu.update-notifier no-show-notifications true
sudo sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades
# >>>Disable application popup
gsettings set org.gnome.desktop.notifications show-banners false
