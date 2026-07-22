#!/bin/bash
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
cd $SCRIPT_DIR/modules
# Ubuntu apps
bash hstr.sh
bash sublimetext3.sh
bash ubuntu_tools.sh
bash japanese_input.sh
# Ubuntu configs
bash dark_theme.sh
bash disable_update.sh
bash hide_ubuntu_pro.sh
bash log_size_limit.sh
bash popup_block.sh
bash set_wallpaper.sh
# Fonts
bash consolas.sh
bash ricty.sh
bash ricty_diminished.sh

