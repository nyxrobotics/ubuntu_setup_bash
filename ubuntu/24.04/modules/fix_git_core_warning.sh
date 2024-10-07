#!/bin/bash

sudo apt-key del 8F1B6217
sudo add-apt-repository --remove "https://ppa.launchpadcontent.net/git-core/ppa/ubuntu"
sudo add-apt-repository ppa:git-core/ppa

