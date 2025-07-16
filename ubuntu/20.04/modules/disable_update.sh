#!/bin/bash

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
cd $SCRIPT_DIR

# >>> Disable update

# Snap
sudo snap remove snapd-desktop-integration
# snap refresh --hold
# sudo snap remove $(snap list | awk ' !/^Name|^core/ {print $1}')
# sudo apt remove --purge -y snapd

# Services
sudo systemctl disable --now unattended-upgrades
sudo systemctl disable --now apt-daily.service apt-daily-upgrade.service
sudo systemctl disable --now apt-daily.timer apt-daily-upgrade.timer
# sudo systemctl disable --now snapd.socket
# sudo systemctl disable --now snapd
sudo systemctl stop unattended-upgrades
sudo systemctl stop apt-daily.service apt-daily-upgrade.service
sudo systemctl stop apt-daily.timer apt-daily-upgrade.timer
# sudo systemctl stop snapd.socket
# sudo systemctl stop snapd

# Gsettings
gsettings set com.ubuntu.update-notifier hide-reboot-notification true
gsettings set com.ubuntu.update-notifier no-show-notifications true
gsettings set org.gnome.desktop.notifications show-banners false

# Desktop
# gconftool -s --type bool /apps/update-notifier/auto_launch false
# sudo mv /etc/xdg/autostart/update-notifier.desktop /etc/xdg/autostart/update-notifier.desktop.back

# Remove gnome packages
sudo apt remove --purge -y unattended-upgrades gnome-software-plugin-snap
sudo rm /var/log/unattended-upgrades/*
