#!/bin/bash

# Disable uvcdynctrl logging (For realsense)
# Reference: https://www.reddit.com/r/Ubuntu/comments/rm2kqi/getting_back_hard_disk_space_really_huge_logfile/
sudo rm -f /var/log/uvcdynctrl-udev.log
sudo ln -s /dev/null /var/log/uvcdynctrl-udev.log

# Limot system log
# Reference: https://stackoverflow.com/questions/35638219/ubuntu-large-syslog-and-kern-log-files

sudo systemctl restart syslog

# Delete archived journal
sudo journalctl --vacuum-size=50M