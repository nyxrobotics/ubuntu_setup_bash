#!/bin/bash

mkdir -p "$HOME/lib/anaconda"
cd "$HOME/lib/anaconda"
if [ ! -x "$HOME/anaconda3/bin/conda" ]; then
    wget -O anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
    bash anaconda.sh -b -p "$HOME/anaconda3"
fi
export PATH="$HOME/anaconda3/bin:$PATH"
if ! grep -Fxq "## Conda paths" ~/.bashrc
then
    echo -e "\n## Conda paths"  >> ~/.bashrc
    echo 'export PATH="/home/$USER/anaconda3/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
fi
