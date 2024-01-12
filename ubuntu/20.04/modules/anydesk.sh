#!/bin/bash
#sudo rm /etc/apt/sources.list.d/anydesk-stable.list*
#sudo rm /etc/apt/keyrings/anydesk.gpg
#sudo rm /usr/share/keyrings/anydesk.gpg
wget -O- https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo gpg --dearmor | sudo tee /usr/share/keyrings/anydesk.gpg > /dev/null
echo deb [signed-by=/usr/share/keyrings/anydesk.gpg] http://deb.anydesk.com/ all main | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
sudo apt update && sudo apt -y install anydesk
