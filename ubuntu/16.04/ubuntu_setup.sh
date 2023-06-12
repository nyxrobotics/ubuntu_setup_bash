#!/bin/bash
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
cd $SCRIPT_DIR/modules/drivers
bash rtl8814au.sh
bash iwlwifi.sh
cd $SCRIPT_DIR/modules
bash ubuntu_tools.sh
bash popup_block.sh
bash set_wallpaper.sh
bash ricty.sh
bash sublimetext3.sh
bash nvidia.sh
