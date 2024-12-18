#!/usr/bin/bash

if [ "$(id -u)" -eq 0 ]; then
    echo "This script must not be run as root. don't use sudo" >&2
    exit 1
fi

echo "starting install of gyro fix"

sudo cp ../suspend-mods.sh /usr/local/bin/suspend-mods
sudo cp ../resume-mods.sh /usr/local/bin/resume-mods

sudo chmod +x /usr/local/bin/suspend-mods
sudo chmod +x /usr/local/bin/resume-mods

sudo chcon -u system_u -r object_r --type=bin_t /usr/local/bin/suspend-mods
sudo chcon -u system_u -r object_r --type=bin_t /usr/local/bin/resume-mods

# disable services if they already exist
sudo systemctl disable --now resume-mods.service
sudo systemctl disable --now suspend-mods.service

sudo cp ../resume-mods.service /etc/systemd/system
sudo cp ../suspend-mods.service /etc/systemd/system

sudo systemctl daemon-reload
sudo systemctl enable resume-mods.service
sudo systemctl enable suspend-mods.service

echo "installation complete!"

sudo rm -rf /tmp/gpd-win-tricks
