#!/usr/bin/bash

if [ "$(id -u)" -eq 0 ]; then
    echo "This script must not be run as root. don't use sudo" >&2
    exit 1
fi

echo "disabling legacy version of fix, assuming it was previously installed"

sudo systemctl disable --now gyro-resume-fix.service
sudo systemctl disable --now gyro-suspend-fix.service

sudo rm /usr/local/bin/suspend-mods
sudo rm /usr/local/bin/resume-mods

sudo rm /etc/systemd/system/gyro-resume-fix.service
sudo rm /etc/systemd/system/gyro-suspend-fix.service

# end disablign of legacy version of fix

echo "starting install of gyro fix"

# remove if somehow already present
sudo rm -rf /tmp/gpd-win-tricks

cd /tmp

git clone https://github.com/aarron-lee/gpd-win-tricks.git

cd gpd-win-tricks/win4-suspend-mods

sudo cp ./suspend-mods.sh /usr/local/bin/suspend-mods
sudo cp ./resume-mods.sh /usr/local/bin/resume-mods

sudo chmod +x /usr/local/bin/suspend-mods
sudo chmod +x /usr/local/bin/resume-mods

sudo chcon -u system_u -r object_r --type=bin_t /usr/local/bin/suspend-mods
sudo chcon -u system_u -r object_r --type=bin_t /usr/local/bin/resume-mods

# disable services if they already exist
sudo systemctl disable --now resume-mods.service
sudo systemctl disable --now suspend-mods.service

sudo cp resume-mods.service /etc/systemd/system
sudo cp suspend-mods.service /etc/systemd/system

sudo systemctl daemon-reload
sudo systemctl enable resume-mods.service
sudo systemctl enable suspend-mods.service

echo "installation complete!"

sudo rm -rf /tmp/gpd-win-tricks
