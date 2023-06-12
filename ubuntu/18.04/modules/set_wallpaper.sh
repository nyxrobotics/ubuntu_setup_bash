#!/bin/bash

# >>>set wallpaper
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
cd $SCRIPT_DIR/../../wallpaper
WALLPAPER_DIR=$(pwd)
#echo -e ¨$WALLPAPER_DIR/happy.png¨
gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_DIR/happy.png"

#disable trash icon
gsettings set org.gnome.nautilus.desktop trash-icon-visible false
#gsettings set org.gnome.shell.extensions.desktop-icons show-home false
