#!/usr/bin/bash

if [ "$(id -u)" -eq 0 ]; then
    echo "This script must not be run as root. don't use sudo" >&2
    exit 1
fi

echo "starting install of clear waydroid desktop entries"

# remove if somehow already present
sudo rm -rf /tmp/gpd-win-tricks

cd /tmp

git clone https://github.com/aarron-lee/gpd-win-tricks.git

cd gpd-win-tricks/clear-waydroid-desktop-entries

# disable services if they already exist
sudo systemctl disable --now clear-waydroid-entries.service
sudo systemctl disable --now clear-waydroid-entries.timer

sudo rm /etc/systemd/system/clear-waydroid-entries.service
sudo rm /etc/systemd/system/clear-waydroid-entries.timer

CLEAR_WAYDROID_SCRIPT=/usr/local/bin/clear-waydroid-entries

sudo cat << EOF > "./clear-waydroid-entries"
#!/bin/bash

rm -f $HOME/.local/share/applications/waydroid.*.desktop
echo "cleared waydroid desktop entries"
EOF

sudo mv ./clear-waydroid-entries $CLEAR_WAYDROID_SCRIPT

sudo chmod +x $CLEAR_WAYDROID_SCRIPT

sudo chcon -u system_u -r object_r --type=bin_t $CLEAR_WAYDROID_SCRIPT

sudo cp ./clear-waydroid-entries.service /etc/systemd/system/clear-waydroid-entries.service
sudo cp ./clear-waydroid-entries.timer /etc/systemd/system/clear-waydroid-entries.timer

# sudo chcon -u system_u -r object_r --type=bin_t /etc/systemd/system/clear-waydroid-entries.timer
# sudo chcon -u system_u -r object_r --type=bin_t /etc/systemd/system/clear-waydroid-entries.service

sudo systemctl daemon-reload
sudo systemctl start clear-waydroid-entries.service
sudo systemctl enable --now clear-waydroid-entries.timer

echo "installation complete!"

cd

sudo rm -rf /tmp/gpd-win-tricks
