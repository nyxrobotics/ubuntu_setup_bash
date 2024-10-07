#!/bin/bash
if ! grep -Fxq "## Enable catkin-tools" ~/.bashrc
then
    echo -e "\n## Enable catkin-tools"  >> ~/.bashrc
    echo 'source `catkin locate --shell-verbs`' >> ~/.bashrc
fi
source ~/.bashrc # reload .bashrc
