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
  - gyro support requires an extra fix, details [here](./win4-suspend-mods/README.md)
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

The 2024 Win Mini may require the  [gyro workaround](./win4-suspend-mods/README.md), it should be the same workaround as the one for the 2025 win mini. Thanks to [PluvIIter](https://github.com/aarron-lee/gpd-win-tricks/issues/8 and Reddit reports

The only issue that you may encounter is the screen being the wrong orientation in gamescope-session/game mode. This is due to the portrait screen on the 7840u model, vs the native landscape screen on the 8840u model. This issue is easy to workaround by changing the relevant kernel arg for orientation.

Trigger or joystick calibration can be done in Windows by using the GPD calibration tool. Thanks [@Trossaloss](https://github.com/aarron-lee/gpd-win-tricks/issues/6)!

## GPD Win Mini (2025)

The 2025 GPD Win mini has a different gyro, so the [gyro workaround](./win4-suspend-mods/README.md) is required for to get it working. Thanks to [PluvIIter](https://github.com/aarron-lee/gpd-win-tricks/issues/8#issuecomment-2728278813) for the info.

Also, the Win Mini uses a new controller. This means that previous GPD WinControl plugins are unable to modify the R4/L4 buttons. Note, even the official WinControls app still needs an update to make it work, it's not available yet. Thanks to [PluvIIter](https://github.com/aarron-lee/gpd-win-tricks/issues/8#issuecomment-2728278813) for this info.

## GPD Win Max 2

The WM2 is mostly usable with Linux, but does have some bugs

- standard stuff like controller hardware, wifi, bluetooth, sound, etc, all work fine
- suspend breaks if you install your OS on the 2230 secondary m2 SSD
- the gyro is buggy/broken, requires dev work to be usable
- suspend on the 6800u model can be fully fixed via fixes descibed in this repo
  - newer WM2 variants (7840u, etc) have bugs with suspend, see [here](https://gitlab.freedesktop.org/drm/amd/-/issues/3154) for details
  - there is an experimental workaround that helps with suspend, see [here](#workaround-for-random-wakes-from-suspend-experimental)
- Fan control is possible via Decky Plugin
- (untested) according to GPD, fingerprint scanner driver is available: https://github.com/ericlinagora/libfprint-CS9711

# GPD Win 2 (m3-7y30)

Mostly functional with Bazzite, you may encounter a bug where the screen is blank/black during the install process. Workaround is to plug in an external monitor, display via usb-c adapter should work fine too.

You can use SDTDP for basic EPP/governor controls. TDP controls don't work at the moment.

See here for fan fix: https://github.com/aarron-lee/bazzite-win2

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
- Gyro requires fix on Bazzite, see [here](./win4-suspend-mods/README.md)

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

read [here](./win4-suspend-mods/README.md) for instructions to setup fix.

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

The fingerprint scanner has been found to cause suspend issues, we can disable it with a udev rule

Note that this fix should already be shipping on the latest Bazzite.

<!-- SUBSYSTEM=="usb", ATTR{idVendor}=="2541", ATTR{idProduct}=="9711", ATTR{authorized}="0" -->

```
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2541", ATTR{idProduct}=="9711", ATTR{remove}="1"' | sudo tee -a /etc/udev/rules.d/99-block-fingerprint.rules
```

### GPD Win Max 2 2025 Suspend issue fix (tentative)

According to user wildi630 on Discord, he managed to fix the sleep/hibernate issues thanks to https://github.com/Sabrina-Fox/WM2-Help?tab=readme-ov-file#known-wm2-2023-specific-issues-linux

For the wm2 2025 he only had to disable the second i2c device:

```bash
echo disabled > /sys/bus/i2c/devices/i2c-PNP0C50:00/power/wakeup
```

he didn't need to disable any of the acpi wakeups

this has not yet been thoroughly tested on multiple devices

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

## GPD Win mini 2024

### Fix default microphone device (Bazzite)

follow instructions from [this](https://universal-blue.discourse.group/t/legion-go-microphone-does-not-default-to-correct-card-in-gamemode/3215/4), but replace the node name

For the node name, this should be changed to "alsa_input.pci-0000_c3_00.6.analog-stereo" instead of the guide's "alsa_input.pci-0000_c2_00.6.analog-stereo".

Thanks [@Trossaloss](https://github.com/aarron-lee/gpd-win-tricks/issues/6)!

### Fix some crashes with eGPU + Bazzite

If you are using a GPD G1 eGPU, repeated crashes due to PCIe Bus Errors can be resolved by adding 'pci=nommconf' to your kernel arguments.

The following command will take care of this on Bazzite: `rpm-ostree kargs --append-if-missing="pci=nommconf"`

Thanks [@Trossaloss](https://github.com/aarron-lee/gpd-win-tricks/issues/6)!

# Mini-guides

### How to change display scaling on internal display

Follow the below steps to enable UI scaling for the internal display:

1. In Steam Game mode, under system settings enable Developer mode
2. A new section appears on the left hand side named "Developer", go in there and enable "Show display scaling settings for Internal Display".
3. The new display scaling options will now be available under Display.
4. Disable developer mode under Steam's System settings, the display scaling options will still be available after disabling developer mode. Enjoy!

source: https://www.reddit.com/r/SteamDeck/comments/17qhmpg/comment/k8dgjnq/

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

https://www.thingiverse.com/thing:6656330


<!--
cat /etc/udev/rules.d/50-horipad-steam-controller.rules
# Wireless HORIPAD STEAM; Bluetooth
KERNEL=="hidraw*", KERNELS=="*0F0D:0196*", MODE="0660", TAG+="uaccess"
KERNEL=="hidraw*", ATTRS{idVendor}=="0f0d", ATTRS{idProduct}=="0196", MODE="0660", TAG+="uaccess"

# Wired HORIPAD STEAM; USB
KERNEL=="hidraw*", KERNELS=="*0F0D:01AB*", MODE="0660", TAG+="uaccess"
KERNEL=="hidraw*", ATTRS{idVendor}=="0f0d", ATTRS{idProduct}=="01ab", MODE="0660", TAG+="uaccess"
-->
