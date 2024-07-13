# gpd-win-tricks

Info on running linux on GPD Win devices.

- [Current Status of Linux on GPD devices](#current-status-of-linux-on-gpd-devices)
- [What Works?](#what-works)
- [Known Bugs](#known-bugs)
- [Resources](#resources)
- [Tutorial Videos](#tutorial-videos)
- [Mini Guides](#mini-guides)
- [3D prints](#3d-prints)

# Current Status of Linux on GPD Devices

Note that Linux is fairly usable as a daily driver, but depending on the device you may encounter some issues.

Also note that these devices might have issues with HDMI 2.1 on Linux.

# What works?

## GPD Win 4 (6800u and 7840u)

All hardware, excluding the FP sensor, is usable with Linux. Note that this has only been confirmed on the 6800u and 7840u versions.

This includes the following:

- full controller + back buttons + gyro support in Steam input via Dualsense Edge emulation (currently requires installing Handheld Daemon)
  - optical mouse nub cannot be used in steam input because it's hardware implementation makes it impossible to treat as a trackpad
  - gyro support requires an extra fix, details [here](./win4-gyro-suspend-fix/README.md)
- TDP control can be done via either Decky Plugins or HHD
- RGB control works via Decky Plugins or HHD
- suspend-resume works
- GPD's mouse/desktop mode works
- all standard hardware works, including wifi, bluetooth, the USB port, sound, volume buttons, the physical keyboard and mouse nub, etc
  - note, for some of this hardware to work, you must be on the latest bios for the 6800u Win 4
  - oculink hasn't been confirmed to work with eGPUs, but it should work with AMD eGPUs
- fan control is possible via Decky Plugin
- while there technically is a fingerprint reader driver, it is outdated and doesn't work on newer versions of Linux. see [here](https://github.com/mrrbrilliant/ft9201-static) for the outdated driver

## GPD Win 4 (8840u)

Mostly the same as the 6800u/7840u version, but there's some reports that suspend-resume might have broken in a recent update.

## GPD Win Max 2 (6800u)

The WM2 is mostly usable with Linux, but does have some bugs

- standard stuff like controller hardware, wifi, bluetooth, sound, etc, all work fine
- the gyro is buggy, requires dev work to be usable
- suspend can occasionally take a long time to fully wake up the device
  - suspend fixes in this repo doen't completely solve the suspend issues
- Fan control is possible via Decky Plugin

## GPD Win Mini

Not confirmed, but most of the GPD Win 4 info applies to the Win mini, including the extra gyro fix. Still needs additional confirmation from more users

# Known bugs

- (2024-5-13) Bazzite - There are reports of black screen, refresh rate and FPS limiters not working, as well as black screen on boot. this is likely due to a new gamescope update on Bazzite
  - workaround: rollback to the last version of bazzite with old gamescope, the 2024-04-27 image, if you need a tutorial video, see here https://www.youtube.com/watch?v=gE1ff72g2Gk
    - run in terminal for rollback: `bazzite-rollback-helper rebase 40-20240427`
  - if you can't boot for to rollback, press esc during boot to bring up the grub menu. use the grub menu to boot your previous BazziteOS install. And from there, do the rebase command
  - for to go back to normal updates later, run: `bazzite-rollback-helper rebase stable`

## GPD Win 4

- Volume buttons require v3.06 or newer bios on the 6800u win 4
- Gyro requires fix on Bazzite, see [here](./win4-gyro-suspend-fix/README.md)

# Resources

HHD Decky Plugin - https://github.com/hhd-dev/hhd-decky

RGB Control + Button Remapping

- GPD-WinControl https://github.com/honjow/GPD-WinControl

TDP Control:

- PowerControl - https://github.com/mengmeet/PowerControl
- SimpleDeckyTDP - https://github.com/aarron-lee/SimpleDeckyTDP/
  - use with PowerControl Fork for fan controls - https://github.com/aarron-lee/PowerControl

RGB-only controls for 6800u Win 4:

- GPD Control https://github.com/aarron-lee/GpdControl/

(Untested) RGB controls plugin: https://github.com/honjow/HueSync

More Win 4 resources: https://github.com/lertsoft/GPD_WIN4/releases

# Tutorial Videos

Win 4 setup Guide: https://www.youtube.com/watch?v=lnNfMY9kzjk

Dual Boot Setup Videos:

- https://www.youtube.com/watch?v=45P3hlvq8jk
- https://www.youtube.com/watch?v=RUES5B5j6EU

# GPD Win 4

## Bazzite OS

### Recommended settings to change in game mode

Under display settings in game mode, change the settings for the following:

- `Use Native Color Temperature` - Enabled
- `Enable Unified Frame Limit Management` - Disabled

You'll need the separated FPS limiter for FPS limits

### Disable FP Sensor (6800u, untested on newer win 4 models)

Since the GPD Win 4 Fingerprint Sensor doesn't work on Linux, we can disable it to make sure it doesn't interfere with suspend, etc.

Run the following in terminal, then reboot the device.

```
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2808", ATTR{idProduct}=="9338", ATTR{remove}="1"' | sudo tee -a /etc/udev/rules.d/99-block-fingerprint.rules
```

### Fix gyro + hhd after suspend-resume cycles

read [here](./win4-gyro-suspend-fix/README.md) for instructions to setup fix.

Applies to the Win 4 6800u, 7840u, 8840u, and apparently also works on the Win Mini (confirmation required for Win Mini)

based on this patch that had previously shipped with Bazzite: https://github.com/ublue-os/bazzite/commit/04929200614a16c16d22854924a42f42561049d8

### HHD back buttons

As documented in HHD's docs [here](https://github.com/hhd-dev/hhd?tab=readme-ov-file#extra-steps-gpd-win-devices), you need to remap the back buttons via GPD Control for them to work in steam input.

use the `GPD-WinControl` decky plugin ([here](https://github.com/honjow/GPD-WinControl)), and set L4 to SYSRQ and R4 to PAUSE

### Fan Control

use PowerControl or PowerControl-Fork decky plugins

## GPD Win Max 2 (6800u)

### Help Fix flaky suspend

The fingerprint scanner has been found to cause suspend issues. Since the fingerprint scanner is non-functional on Linux, we can disable it with a udev rule

<!-- SUBSYSTEM=="usb", ATTR{idVendor}=="2541", ATTR{idProduct}=="9711", ATTR{authorized}="0" -->

```
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2541", ATTR{idProduct}=="9711", ATTR{remove}="1"' | sudo tee -a /etc/udev/rules.d/99-block-fingerprint.rules
```

other changes that may help:

run [wm2-suspend-udev.sh](./wm2-suspend-udev.sh)

Note that the Win 4 gyro fix can also help fix odd suspend behavior on the Win Max 2 + any other distros with the gyro driver installed. Note that this might not fully fix suspend.

# Mini-guides

### failure to partition for dual boot

reported by @Tiaph on Discord, the bazzite installer refused to partition for dual boot.

```
Failure to add the device
Unable to allocate requested partition scheme.
```

as a solution, you can create the partitions in Windows, then have the bazzite installer take control over each partition individually. solution based on [this](https://discussion.fedoraproject.org/t/dual-boot-with-windows-10-installation-error/73430/29)

# 3d prints

https://www.reddit.com/r/gpdwin/comments/14c5cvp/i_made_a_set_of_win_4_front_covers/

https://sketchfab.com/3d-models/gpd-win-4-grips-6c8c02d6dac047c6b0214a1e4384a096
