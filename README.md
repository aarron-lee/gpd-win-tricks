# gpd-win-tricks

Info on running linux on GPD Win devices.

# Resources

HHD Decky Plugin - https://github.com/hhd-dev/hhd-decky

RGB Control + Button Remapping

- GPD-WinControl https://github.com/honjow/GPD-WinControl

TDP Control:

- PowerControl - https://github.com/mengmeet/PowerControl
- SimpleDeckyTDP - https://github.com/aarron-lee/SimpleDeckyTDP/
  - use with PowerControl Fork - https://github.com/aarron-lee/PowerControl

# GPD Win 4 (6800u)

## Bazzite OS

### Fix gyro + hhd after suspend-resume cycles

run the [install script](./win4-gyro-suspend-fix/install.sh) for to setup systemd services

source of original patch, which has been removed from Bazzite: https://github.com/ublue-os/bazzite/commit/04929200614a16c16d22854924a42f42561049d8

## GPD Win Max 2 (6800u)

### Help Fix flaky suspend

run [wm2-suspend-udev.sh](./wm2-suspend-udev.sh)

# 3d prints

https://www.reddit.com/r/gpdwin/comments/14c5cvp/i_made_a_set_of_win_4_front_covers/

https://sketchfab.com/3d-models/gpd-win-4-grips-6c8c02d6dac047c6b0214a1e4384a096
