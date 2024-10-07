#!/bin/bash

# >>>set wallpaper
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
cd $SCRIPT_DIR/../../wallpaper
WALLPAPER_DIR=$(pwd)
#echo -e ¨$WALLPAPER_DIR/black.png¨
gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_DIR/black.png"

### Disable desktop icons
### Reference: https://askubuntu.com/questions/1335398/ubuntu-21-04-remove-trash-user-and-drive-icon-from-desktop
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.gnome.shell.extensions.ding show-trash false
gsettings set org.gnome.shell.extensions.ding show-home false
gsettings set org.gnome.shell.extensions.ding show-volumes false
gsettings set org.gtk.Settings.FileChooser show-hidden true
