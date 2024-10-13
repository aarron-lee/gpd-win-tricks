#!/usr/bin/bash

if [ "$(id -u)" -eq 0 ]; then
    echo "This script must not be run as root. don't use sudo" >&2
    exit 1
fi

echo "starting install of wm2 resume workaround"

# remove if somehow already present
sudo rm -rf /tmp/gpd-win-tricks

cd /tmp

git clone https://github.com/aarron-lee/gpd-win-tricks.git

cd gpd-win-tricks/wm2-wakeup-workaround
sudo cp ./wm2-resume-mods.sh /usr/local/bin/wm2-resume-mods

sudo chmod +x /usr/local/bin/wm2-resume-mods

sudo chcon -u system_u -r object_r --type=bin_t /usr/local/bin/wm2-resume-mods

# disable services if they already exist
sudo systemctl disable --now wm2-resume-fix.service

sudo cp wm2-resume-fix.service /etc/systemd/system

sudo systemctl daemon-reload
sudo systemctl enable wm2-resume-fix.service

echo "installation complete!"

sudo rm -rf /tmp/gpd-win-tricks
