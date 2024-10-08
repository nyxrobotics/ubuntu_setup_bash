#!/bin/bash

sudo apt-key del 8F1B6217
sudo apt-key del DC282033

sudo add-apt-repository --remove ppa:git-core/ppa
sudo add-apt-repository ppa:git-core/ppa
