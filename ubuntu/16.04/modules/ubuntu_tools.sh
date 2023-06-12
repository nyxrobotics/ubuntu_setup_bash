#!/bin/bash

# >>>Disable suspend
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
# >> Re-enable
# sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
# >>>Install unity-tweak-tool(GUI-Theme)
sudo add-apt-repository -y ppa:noobslab/themes
sudo apt update
sudo apt install -y unity-tweak-tool hud arc-theme
# >>>Install synaptic and aptitude (debian package managers) and htop (CUI resource monitor)
sudo apt install -y synaptic aptitude htop
# >>>Install terminator(set as default terminal)
sudo apt install -y terminator
gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/terminator
gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"
# >>>Disable crash report
sudo rm /var/crash/*
sudo systemctl disable apport
sudo apt purge -y apport
# >>>Hide launcher
# dconf write "/org/compiz/profiles/unity/plugins/unityshell/launcher-hide-mode" 1 #Please toggle here 1/0
# >>>Disable lock-screen
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.lockdown disable-lock-screen true
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
# >>>Auto-login
sudo echo -e "[Seat:*]\nautologin-guest=false\nautologin-user=$USER\nautologin-user-timeout=0"  > /etc/lightdm/lightdm.conf
# >>>Install Mozc(Japanese input)
sudo apt install -y ibus-mozc
killall ibus-daemon
ibus-daemon -d -x &
