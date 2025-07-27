# Overview

This repo has fixes for the GPD Win 2 + Bazzite. This uses nbfc for fan controls.

# Note:
 - nbfc requires secure boot to be disabled at BIOS, if you need to reboot directly to BIOS you can run
`sudo systemctl reboot --firmware-setup`

# Bazzite instructions

Tested in Bazzite v41 on a GPD Win 2 m3-7y30. nbfc does need to be manually installed for fan controls.

You may encounter a bug where the screen is blank/black during the install process. Workaround is to plug in an external monitor while booting the installer, display via usb-c adapter should work fine too.

```bash
# installs nbfc
curl -L https://github.com/aarron-lee/gpd-win-tricks/raw/main/win2/bazzite_fix.sh | sh
```

For better controller support, you can install a fork of hhd with support for the win 2. The GPD Win 2's identifier (dmi) unfortunately is `Default string`, which makes it impractical for upstream hhd to identify the device properly. You should be able to install it with the following in terminal:

```bash
curl -L https://github.com/aarron-lee/hhd/raw/gpdwin2/dev/bazzite_hhd_local_install.sh | sh
```

You can use [SimpleDeckyTDP](https://github.com/aarron-lee/SimpleDeckyTDP) for TDP, EPP, and power governor controls.

You can also use [steam-powerbuttond](https://github.com/ShadowBlip/steam-powerbuttond) for to get the power button to sleep the device.

```bash
curl -L https://github.com/ShadowBlip/steam-powerbuttond/raw/main/bazzite_install.sh | sh
```

# Attribution

Major thanks to paco for figuring out the issues for the GPD Win 2, you can see his original repo here: https://github.com/pacoa-kdbg/chimeraOS-win2
