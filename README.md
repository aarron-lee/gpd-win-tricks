# gpd-win-tricks

Info on running linux on GPD Win devices.

- [Current Status of Linux on GPD devices](#current-status-of-linux-on-gpd-devices)
- [What Works?](#what-works)
- [Known Bugs](#known-bugs)
- [Resources](#resources)
- [Tutorial Videos](#tutorial-videos)
- [Mini Guides](#mini-guides)
  - [How to change display scaling on internal display](#how-to-change-display-scaling-on-internal-display)
  - [How do gamescope scaling options work?](#how-to-use-steams-scaling-features-such-as-int-scaling-fsr-etc)
- [3D prints](#3d-prints)

# Current Status of Linux on GPD Devices

Note that Linux is fairly usable as a daily driver, but depending on the device you may encounter some issues.

Also note that these devices might have issues with HDMI 2.1 on Linux.

# What works?

## GPD Win 4 (6800u only)

All hardware, excluding the FP sensor, is usable with Linux. Note that this has been confirmed on the 6800u versions.

7840u and 8840u models have reported suspend-resume issues.

This includes the following:

- full controller + back buttons + gyro support in Steam input via Dualsense Edge emulation (currently requires installing Handheld Daemon)
  - optical mouse nub cannot be used in steam input because it's hardware implementation makes it impossible to treat as a trackpad
  - gyro support requires an extra fix, details [here](./win4-gyro-suspend-fix/README.md)
- TDP control can be done via either Decky Plugins or HHD
- RGB control works via Decky Plugins
  - there is also an untested RGB driver here - https://github.com/bm16ton/gpd-win4-rgb
- suspend-resume works
  - make sure you [fully disable the fp sensor](#disable-fp-sensor-6800u-untested-on-newer-win-4-models) so that it doesn't cause suspend-resume issues
- GPD's mouse/desktop mode works
- all standard hardware works, including wifi, bluetooth, the USB port, sound, volume buttons, the physical keyboard and mouse nub, etc
  - note, for some of this hardware to work, you must be on the latest bios for the 6800u Win 4
  - oculink hasn't been confirmed to work with eGPUs, but it should work with AMD eGPUs
- fan control is possible via Decky Plugin
- while unconfirmed, there is a fingerprint reader driver for the win 4 here: https://github.com/bm16ton/ft92010x9338
  - there is also an outdated proprietary driver [here](https://github.com/mrrbrilliant/ft9201-static)
  - another available driver [here](https://github.com/banianitc/ft9201-fingerprint-driver)

### GPD Win 4 (7840u, 8840u, newer models)

Everything for the 6800u version applies, but there's been reports of a suspend issue where it wakes up after some time in suspend.

It resembles the issue affecting the WM2 7840u/8840u, detailed bug report for the WM2 can be found [here](https://gitlab.freedesktop.org/drm/amd/-/issues/3154)

Unfortunately there's no known fix, GPD would need to release a bios update to address it

## GPD Win Mini

Most of the GPD Win 4 info applies to the Win Mini, including the extra gyro fix. The Win Mini has no FP sensor, so that does not apply.

Users have confirmed that suspend-resume works fine for all models, all general hardware (controller, bluetooth, wifi, etc) works fine, etc. There's no major reported issues.

The only issue that you may encounter is the screen being the wrong orientation in gamescope-session/game mode. This is due to the portrait screen on the 7840u model, vs the native landscape screen on the 8840u model. This issue is easy to workaround by changing the relevant kernel arg for orientation.

## GPD Win Max 2

The WM2 is mostly usable with Linux, but does have some bugs

- standard stuff like controller hardware, wifi, bluetooth, sound, etc, all work fine
- suspend breaks if you install your OS on the 2230 secondary m2 SSD
- the gyro is buggy/broken, requires dev work to be usable
- suspend on the 6800u model can be fully fixed via fixes descibed in this repo
  - newer WM2 variants (7840u, etc) have bugs with suspend, see [here](https://gitlab.freedesktop.org/drm/amd/-/issues/3154) for details
  - there is an experimental workaround that helps with suspend, see [here](#workaround-for-random-wakes-from-suspend-experimental)
- Fan control is possible via Decky Plugin

# Known bugs

- gyro is borked on WM2
- gyro on Win 4 requires a workaround (solved on some distros)
- focus issue after resume from suspend, where the game controller seems to be stuck in Steam UI and not getting picked up by the game
  - solution: disable custom wake movies, see github issues [here](https://github.com/ublue-os/bazzite/issues/1474) and [here](https://github.com/ValveSoftware/SteamOS/issues/1424) for more details
- fingerprint scanners can cause flaky suspend
  - workaround: fully disable the fingerprint scanners (instructions listed further below for both the WM2 and Win 4)
- If using Decky loader, shutdown can take an unusually long time
  - this is because Decky sets an unusually long timeout time (45s)
  - workaround: shorten the timeout time:

```
sudo sed -i 's~TimeoutStopSec=.*$~TimeoutStopSec=2~g' /etc/systemd/system/plugin_loader.service
sudo systemctl daemon-reload
```

## GPD Win 4

- Volume buttons require v3.06 or newer bios on the 6800u win 4, found [here](https://github.com/lertsoft/GPD_WIN4/releases/tag/v3.06)
- Gyro requires fix on Bazzite, see [here](./win4-gyro-suspend-fix/README.md)

# Resources

HHD Decky Plugin - https://github.com/hhd-dev/hhd-decky

RGB Control + Button Remapping

- GPD-WinControl https://github.com/honjow/GPD-WinControl

TDP Control:

- PowerControl - https://github.com/mengmeet/PowerControl
- SimpleDeckyTDP - https://github.com/aarron-lee/SimpleDeckyTDP/
  - use with PowerControl Fork for fan controls - https://github.com/aarron-lee/PowerControl
- RGB controls plugin: https://github.com/honjow/HueSync

GPD Wincontrol reverse engineered CLI tool - https://github.com/pelrun/pyWinControls

More Win 4 resources: https://github.com/lertsoft/GPD_WIN4/releases

Controller-friendly Youtube app (with steam input community profile) - https://github.com/Haroon01/youtube-tv-client

Controller-friendly Crunchyroll app (with steam input community profile) - https://github.com/aarron-lee/crunchyroll-linux

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

### Disable FP Sensor on Win 4 to fix suspend-resume

Since the GPD Win 4 Fingerprint Sensor doesn't work on Linux, we can disable it to make sure it doesn't interfere with suspend, etc.

Note that this fix should already be shipping on the latest Bazzite.

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

### Disable FP sensor on WM2 to fix some suspend-resume issues

Note that this fully fixes suspend on the 6800u WM2, but newer models have additional suspend-resume issues

The fingerprint scanner has been found to cause suspend issues. Since the fingerprint scanner is non-functional on Linux, we can disable it with a udev rule

Note that this fix should already be shipping on the latest Bazzite.

<!-- SUBSYSTEM=="usb", ATTR{idVendor}=="2541", ATTR{idProduct}=="9711", ATTR{authorized}="0" -->

```
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2541", ATTR{idProduct}=="9711", ATTR{remove}="1"' | sudo tee -a /etc/udev/rules.d/99-block-fingerprint.rules
```

### Workaround for random wakes from suspend (Experimental)

See Experimental workaround, found [here](./wm2-wakeup-workaround/). This is primarily for newer WM2 models

<!-->

### Help Fix flaky suspend

other changes that may help:

run [wm2-suspend-udev.sh](./wm2-suspend-udev.sh)

Note that the Win 4 gyro fix can also help fix odd suspend behavior on the Win Max 2 + any other distros with the gyro driver installed. Note that this might not fully fix suspend.
-->

## GPD win mini

### Sound EQ

place the `sink-eq6.conf` file in `~/.config/pipewire/filter-chain.conf.d/` directory

this will add a new `GPD Win Mini EQ` device to your sound options.

\*\*WARNING: You MUST max the volume of your regular sound option before switching to the `GPD Win Mini EQ` option. The sound level of the regular option affects the max of the EQ option.

It should be selected by default in game mode because of priority.driver / priority.session, but you can comment those out if you want to select it manually.

Thanks to @justinweiss on Discord for this fix

# Mini-guides

### How to change display scaling on internal display

source: https://www.reddit.com/r/SteamDeck/comments/17qhmpg/comment/k8dgjnq/

Follow the below steps to enable UI scaling for the internal display:

1. Install Decky Plugin loader if you haven't already.
2. Go into Decky Loaders settings and under General enable "Developer mode".
3. A new section appears on the left hand side named "Developer", go in there and enable "Enable Valve Internal".
4. Go into Steam Deck settings and under System enable "Enable Developer Mode".
5. Scroll all the way down in the left hand list and a new section named "Valve Internal" have appeared, go in there. BE CAREFUL HERE, THESE SETTINGS ARE POTENTIALLY DANGEROUS!
6. Scroll down a bit until you see "Show display scaling settings for Internal Display" and enable it. MAKE SURE TO NOT TOUCH ANYTHING ELSE UNLESS YOU KNOW WHAT YOU'RE DOING.
7. The new display scaling options will now be available under Display.
8. Disable developer mode under System.
9. In Decky Loaders settings, disable "Enable Valve Internal" in the Developer section.
10. Still in Decky Loader, disable developer mode under General.

The display scaling options will still be available in the display settings after disabling developer mode. Enjoy!

### How to use steam's scaling features, such as int scaling, FSR, etc

![steam resolutions guide](https://github.com/aarron-lee/legion-go-tricks/blob/main/steam-resolutions-overview.png)

Full guide here: https://medium.com/@mohammedwasib/a-guide-to-a-good-docked-gaming-experience-on-the-steam-deck-346e393b657a

Reddit discussion [here](https://www.reddit.com/r/SteamDeck/comments/z90ca0/a_guide_to_a_good_docked_gaming_experience_on_the/)

PDF Mirror of guide [here](https://github.com/aarron-lee/legion-go-tricks/blob/main/steam-resolutions-guide.pdf)

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
