#!/usr/bin/bash

if [ "$(id -u)" -eq 0 ]; then
    echo "This script must not be run as root. don't use sudo" >&2
    exit 1
fi

echo "starting install of gyro fix"

# remove if somehow already present
sudo rm -rf /tmp/gpd-win-tricks

cd /tmp

git clone https://github.com/aarron-lee/gpd-win-tricks.git

cd gpd-win-tricks/win4-gyro-suspend-fix

sudo cat <<EOF > "/etc/device-quirks/systemd-suspend-mods.conf"
bmi260_i2c
bmi260_core
EOF


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

echo "installation complete!"

sudo rm -rf /tmp/gpd-win-tricks
