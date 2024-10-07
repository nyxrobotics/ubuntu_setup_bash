#!/bin/bash

# Path to the configuration file
CONFIG_FILE="/usr/share/X11/xorg.conf.d/10-nvidia.conf"

# Line to add
OPTION_LINE='    Option "PrimaryGPU" "yes"'

# Check if the file exists
if [[ -f "$CONFIG_FILE" ]]; then
    # Check if "OutputClass" section exists
    if grep -q 'Section "OutputClass"' "$CONFIG_FILE"; then
        # Check if the "PrimaryGPU" option is already present
        if grep -q "$OPTION_LINE" "$CONFIG_FILE"; then
            echo "Option 'PrimaryGPU' is already present."
        else
            # Add the option before the "EndSection"
            sudo sed -i '/EndSection/i\'"$OPTION_LINE" "$CONFIG_FILE"
            echo "Option 'PrimaryGPU' has been added."
        fi
    else
        echo "Error: 'Section \"OutputClass\"' not found in the file."
    fi
else
    echo "Error: File $CONFIG_FILE not found."
fi
