#!/bin/bash

### Reference: https://github.com/littleant/auto-darkmode-switcher/tree/main

# sudo apt install gnome-tweaks libglib2.0-bin

### Dark theme
gsettings set org.gnome.desktop.interface gtk-theme "Yaru-dark"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

### Default theme
# gsettings set org.gnome.desktop.interface gtk-theme "Yaru"
# gsettings set org.gnome.desktop.interface color-scheme prefer-light
