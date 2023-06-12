#!/bin/bash

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
cd $SCRIPT_DIR
# >>>Grub setting
# sudo cp ../config/grub_samples/gs43vr /etc/default/grub
# sudo update-grub
# >>> Disable animation
gsettings set org.gnome.desktop.interface enable-animations false
# >>>Fix "Failed to fetch" error
sudo rm -rf /var/lib/apt/lists/*
# >>>Install synaptic and aptitude (debian package managers) and htop (CUI resource monitor) and git
sudo apt update
sudo apt install -y synaptic aptitude htop git
# >>>Install terminator(set as default terminal)
sudo apt install -y terminator
gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/terminator
gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"
# >>>Disable crash report
sudo rm /var/crash/*
sudo systemctl disable apport
sudo apt purge -y apport
sudo apt autoremove -y
# >>>Hide launcher
gsettings set org.gnome.shell.extensions.dash-to-dock autohide false #Always false
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false #Always false
#gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false #Please toggle here true/false
# >>>Disable lock-screen
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.lockdown disable-lock-screen true
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
# >>>Auto-login (username:$USER)
cp -f ../config/custom.conf ../config/custom_tmp.conf
sed -i 's#username#'"$USER"'#g' ../config/custom_tmp.conf
sudo mv ../config/custom_tmp.conf /etc/gdm3/custom.conf
# >>>Install Mozc(Japanese input)
sudo apt install -y ibus-mozc emacs-mozc
killall ibus-daemon
ibus-daemon -d -x &
# >>>Install tools
sudo apt install gnome-tweak-tool gparted guvcview