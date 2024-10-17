#!/usr/bin/bash

if [ "$(id -u)" -eq 0 ]; then
    echo "This script must not be run as root. don't use sudo" >&2
    exit 1
fi

echo "starting install of mt7921e fix"

# remove if somehow already present
sudo rm -rf /tmp/gpd-win-tricks

cd /tmp

git clone -b mt7921e_fix --single-branch https://github.com/aarron-lee/gpd-win-tricks.git

cd gpd-win-tricks/suspend-fix

sudo cp ./suspend-mods.sh /usr/local/bin/suspend-mods
sudo cp ./resume-mods.sh /usr/local/bin/resume-mods

sudo chmod +x /usr/local/bin/suspend-mods
sudo chmod +x /usr/local/bin/resume-mods

# disable services if they already exist
sudo systemctl disable --now resume-fix.service
sudo systemctl disable --now suspend-fix.service

sudo cp resume-fix.service /etc/systemd/system
sudo cp suspend-fix.service /etc/systemd/system

sudo systemctl daemon-reload
sudo systemctl enable resume-fix.service
sudo systemctl enable suspend-fix.service

echo "installation complete!"

sudo rm -rf /tmp/gpd-win-tricks

# bazzite only

sudo chcon -u system_u -r object_r --type=bin_t /usr/local/bin/suspend-mods
sudo chcon -u system_u -r object_r --type=bin_t /usr/local/bin/resume-mods
