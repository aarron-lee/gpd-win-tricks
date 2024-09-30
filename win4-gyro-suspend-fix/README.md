This workaround has been modified to load and unload the mt7921e wifi driver on suspend-resume cycles, meant as a workaround for specific Ayaneo devices.

# Install instructions

run the following in terminal

```
curl -L https://raw.githubusercontent.com/aarron-lee/gpd-win-tricks/mt7921e_fix/win4-gyro-suspend-fix/install.sh | sh
```

# uninstall instructions

```
sudo systemctl disable --now resume-fix.service
sudo systemctl disable --now suspend-fix.service

sudo rm /usr/local/bin/suspend-mods
sudo rm /usr/local/bin/resume-mods

sudo rm /etc/systemd/system/resume-fix.service
sudo rm /etc/systemd/system/suspend-fix.service
```
