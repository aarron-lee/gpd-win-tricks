# gpd-win-tricks
Info on running linux on GPD Win devices. Note these are my own personal notes for documentation


# GPD Win 4 (6800u)

## Bazzite OS

### Fix gyro + hhd after suspend-resume cycles

Add:

```
bmi260_i2c
bmi260_core
```

To the `/etc/device-quirks/systemd-suspend-mods.conf`, which will reload the gyro driver after suspend-resume cycles

The patch itself is just a script run by systemd:

```bash
# /usr/lib/systemd/system-sleep/systemd-suspend-mods.sh
#!/bin/bash
# This file runs during sleep/resume events. It will read the list of modules
# in /etc/device-quirks/systemd-suspend-mods.conf and rmmod them on suspend,
# insmod them on resume.
# Originally created by ChimeraOS

MOD_LIST=$(grep -v ^\# /etc/device-quirks/systemd-suspend-mods.conf)

case $1 in
    pre)
        for mod in $MOD_LIST; do
            modprobe -r $mod
        done
    ;;
    post)
        for mod in $MOD_LIST; do
            modprobe $mod
        done
    ;;
esac
```

git commit of original patch: https://github.com/ublue-os/bazzite/commit/04929200614a16c16d22854924a42f42561049d8

## GPD Win Max 2 (6800u)

### Fix flaky suspend

run [wm2-suspend-udev.sh](./wm2-suspend-udev.sh)