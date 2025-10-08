#!/bin/bash

# >>>Dark Theme
gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings reset org.gnome.shell.ubuntu color-scheme
# >>>Light Theme
#gsettings set org.gnome.desktop.interface gtk-theme Yaru
#gsettings set org.gnome.desktop.interface color-scheme prefer-light
#gsettings reset org.gnome.shell.ubuntu color-scheme