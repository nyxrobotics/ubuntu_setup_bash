#!/bin/bash

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
cd $SCRIPT_DIR

# >>> Disable update
sudo systemctl disable --now unattended-upgrades
sudo systemctl stop unattended-upgrades
gsettings set com.ubuntu.update-notifier hide-reboot-notification true
gconftool -s --type bool /apps/update-notifier/auto_launch false
sudo mv /etc/xdg/autostart/update-notifier.desktop /etc/xdg/autostart/update-notifier.desktop.back
