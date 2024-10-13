# WM2 wakeup workaround (experimental)

the GPD WM2 (7840u, 8840u) has issues where it will wake up periodically. This workaround attempts to detect if the lid is closed, and initiate a suspend again if it is still closed.

source for original workaround script: https://github.com/SpookOz/spook-wm2/blob/main/wakeup-script.sh

all credit goes to the original dev, @SpookOz

# Install instructions

run the following in terminal

```
curl -L https://raw.githubusercontent.com/aarron-lee/gpd-win-tricks/main/wm2-wakeup-workaround/install.sh | sh
```

You should also make sure that your fingerprint scanner is fully disabled:

```bash
# GPD WM2
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2541", ATTR{idProduct}=="9711", ATTR{remove}="1"' | sudo tee -a /etc/udev/rules.d/99-block-fingerprint.rules

# activate the udev rule, or reboot the system
sudo udevadm control --reload-rules
sudo udevadm trigger
```

# Uninstall instructions

```
sudo systemctl disable --now wm2-resume-fix.service

sudo rm /usr/local/bin/wm2-resume-mods

sudo rm /etc/systemd/system/wm2-resume-fix.service
```

# More info

If you want to verify whether this worked, you can run the following in terminal:

```bash
sudo journalctl | grep "SleepPatch"
```

The output should look something like this:

```bash
Oct 14 14:41:03 bazzite root[365347]: SleepPatch: ---start wm2 resume mods---
Oct 14 14:41:03 bazzite root[365352]: SleepPatch: Lid is closed. Proceeding with suspend checks...
Oct 14 14:41:03 bazzite root[365353]: SleepPatch: Sleeping 60 seconds to wait for system to wake fully.
Oct 14 14:42:04 bazzite root[366136]: SleepPatch: Running post-suspend checks.
Oct 14 14:42:04 bazzite root[366138]: SleepPatch: Checking for suspend inhibitors.
Oct 14 14:42:04 bazzite root[366144]: SleepPatch: No suspend inhibitors found and lid is still closed. Putting the system back to sleep.
Oct 14 14:42:28 bazzite root[366480]: SleepPatch: ---start wm2 resume mods---
Oct 14 14:42:28 bazzite root[366493]: SleepPatch: Lid is open. Nothing to do.
```
