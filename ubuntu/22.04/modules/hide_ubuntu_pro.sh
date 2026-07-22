#!/bin/bash

config=/etc/apt/apt.conf.d/20apt-esm-hook.conf
backup=${config}.bak

if [ -e "$config" ] && [ ! -e "$backup" ]; then
    sudo mv "$config" "$backup"
fi
sudo install -o root -g root -m 0644 /dev/null "$config"
