# Gyro fix

the GPD Win 4 has issues where after suspend-resume cycles, the gyro stops working. This fix creates systemd services that rmmod and modprobe the driver on suspend-resume cycles to fix the issue.

This also works on the GPD Win Mini 2025 (thanks @PluvIIter for the tip!)

Note that this fix has been tested on the 6800u, 7840u, and 8840u GPD Win 4 devices

# Install instructions

## If you're on Bazzite + ChimeraOS, YOU NO LONGER NEED THIS WORKAROUND for the Win 4, it should be built into Bazzite now

## the Win Mini 2025 currently still needs this workaround. The win mini 2024 might also need this workaround

run the following in terminal

```bash
# for the GPD Win Mini 2025
curl -L https://raw.githubusercontent.com/aarron-lee/gpd-win-tricks/main/win4-suspend-mods/install_mini_2025.sh | sh

# for the GPD Win 4
curl -L https://raw.githubusercontent.com/aarron-lee/gpd-win-tricks/main/win4-suspend-mods/install.sh | sh
```

# uninstall instructions

```
sudo systemctl disable --now resume-mods.service
sudo systemctl disable --now suspend-mods.service

sudo rm /usr/local/bin/suspend-mods
sudo rm /usr/local/bin/resume-mods

sudo rm /etc/systemd/system/resume-mods.service
sudo rm /etc/systemd/system/suspend-mods.service
```
