# Gyro fix

the GPD Win 4 has issues where after suspend-resume cycles, the gyro stops working. This fix creates systemd services that rmmod and modprobe the driver on suspend-resume cycles to fix the issue.

Note that this fix has been tested on the 6800u, 7840u, and 8840u GPD Win 4 devices

# Install instructions

## If you're on Bazzite, YOU NO LONGER NEED THIS WORKAROUND, it should be built into Bazzite now

run the following in terminal

```
curl -L https://raw.githubusercontent.com/aarron-lee/gpd-win-tricks/main/win4-gyro-suspend-fix/install.sh | sh
```

# uninstall instructions

```
sudo systemctl disable --now gyro-resume-fix.service
sudo systemctl disable --now gyro-suspend-fix.service

sudo rm /usr/local/bin/suspend-mods
sudo rm /usr/local/bin/resume-mods

sudo rm /etc/systemd/system/gyro-resume-fix.service
sudo rm /etc/systemd/system/gyro-suspend-fix.service
```
