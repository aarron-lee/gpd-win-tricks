#!/usr/bin/bash

if [ "$(id -u)" -e 0 ]; then
    echo "This script must not be run as root." >&2
    exit 1
fi

sudo cp ./suspend-mods.sh /usr/local/bin/suspend-mods
sudo cp ./resume-mods.sh /usr/local/bin/resume-mods

sudo chmod +x /usr/local/bin/suspend-mods
sudo chmod +x /usr/local/bin/resume-mods

sudo chcon -u system_u -r object_r --type=bin_t /usr/local/bin/suspend-mods
sudo chcon -u system_u -r object_r --type=bin_t /usr/local/bin/resume-mods

sudo cp gyro-resume-fix.service /etc/systemd/system
sudo cp gyro-suspend-fix.service /etc/systemd/system

sudo systemctl daemon-reload
sudo systemctl enable --now gyro-resume-fix.service
sudo systemctl enable --now gyro-suspend-fix.service
