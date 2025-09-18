# Overview

This repo has fixes for the GPD Win 2 + Bazzite.

Misc: Remember to loosen the hinge if it's really tight, a tight hinge can eventually lead to damaging your device. See [here](https://old.reddit.com/r/gpdwin/comments/bpv7dp/gpd_win2_how_to_loosen_your_hinge/) for instructions on loosening it (in case of dead link, mirror [here](./tighten_hinge.md)).

# Black screen during Bazzite installation

You may encounter a bug where the screen is blank/black during the install process. Workaround is to plug in an external monitor while booting the installer, display via usb-c adapter should work fine too.

# Fan Control

This uses nbfc for fan controls.

### Note:
 - nbfc requires secure boot to be disabled at BIOS, if you need to reboot directly to BIOS you can run
`sudo systemctl reboot --firmware-setup`

Tested in Bazzite v41 on a GPD Win 2 m3-7y30. nbfc does need to be manually installed for fan controls.

```bash
curl -L https://github.com/aarron-lee/gpd-win-tricks/raw/main/win2/bazzite_fix.sh | sh
```

# Better controller support

For better controller support, you can install a fork of hhd with support for the win 2.

### Note:
- The GPD Win 2's identifier (dmi) unfortunately is `Default string`, which makes it impractical for upstream hhd to identify the device properly.

You should be able to install the fork with the following in terminal:

```bash
curl -L https://github.com/aarron-lee/hhd/raw/gpdwin2/dev/bazzite_hhd_local_install.sh | sh
```

# TDP Control

You can use [SimpleDeckyTDP](https://github.com/aarron-lee/SimpleDeckyTDP) for TDP, EPP, and power governor controls.

# Power Button fix

You can also use [steam-powerbuttond](https://github.com/ShadowBlip/steam-powerbuttond) for to get the power button to sleep the device.

```bash
curl -L https://github.com/ShadowBlip/steam-powerbuttond/raw/main/bazzite_install.sh | sh
```

# Screen rotation fix on Bazzite

If you find your screen rotated 90 degrees in gaming mode, first confirm your screen id with `kscreen-doctor`:
```bash
kscreen-doctor -o
```
On line 1, it should show:
```bash
Output: 1 eDP-1
```
use the following command to update launch parameters to fix the screen orientation. if your screen id is different, replace `eDP-1` with screen id.
```bash
sudo rpm-ostree kargs --append-if-missing=video=eDP-1:panel_orientation=right_side_up
```
# Attribution

Major thanks to paco for figuring out the issues for the GPD Win 2, you can see his original repo here: https://github.com/pacoa-kdbg/chimeraOS-win2
