#!/usr/bin/bash

sudo systemctl disable --now clear-waydroid-entries.service
sudo systemctl disable --now clear-waydroid-entries.timer

sudo rm /etc/systemd/system/clear-waydroid-entries.service
sudo rm /etc/systemd/system/clear-waydroid-entries.timer

sudo rm /usr/local/bin/clear-waydroid-entries

echo "uninstall complete"