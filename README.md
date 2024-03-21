# gpd-win-tricks

Info on running linux on GPD Win devices. Note these are my own personal notes for documentation

# GPD Win 4 (6800u)

## Bazzite OS

### Fix gyro + hhd after suspend-resume cycles

run the [install script](./win4-gyro-suspend-fix/install.sh) for to setup systemd services

git commit of original patch: https://github.com/ublue-os/bazzite/commit/04929200614a16c16d22854924a42f42561049d8

## GPD Win Max 2 (6800u)

### Fix flaky suspend

run [wm2-suspend-udev.sh](./wm2-suspend-udev.sh)
