# Experimental Sound Fix

Experimental sound convolver for the GPD Win 4 and WM2, based on [Legion Go variant](https://github.com/aarron-lee/legion-go-tricks/tree/main/experimental_sound_fix)

For the GPD Pocket 4, see [here](https://kittenlabs.de/blog/2025/04/06/gpd-pocket-4-speaker-dsp/) and [github repo here](https://github.com/Manawyrm/gpd-pocket-4-pipewire)

# Install instructions

run the following in terminal:

```bash
# for GPD Win 4
curl -L https://raw.githubusercontent.com/aarron-lee/gpd-win-tricks/main/experimental_sound_fix/install_sound_fix_win4.sh | sh

# for GPD WM2
curl -L https://raw.githubusercontent.com/aarron-lee/gpd-win-tricks/main/experimental_sound_fix/install_sound_fix_wm2.sh | sh
```

Afterwards, you will see an additional Playback device in your audio options `GPD Win`

## WARNING!

Before you switch to the `GPD Win` option, make sure to max out the audio of your regular speakers sound option! The max volume of your audio speakers affects the volume of the `GPD Win` option.

Also, this fix can affect your HDMI audio. Specifically, it may not automatically swap to HDMI audio when you connect HDMI.

As a workaround, you can setup a config as seen [here](./wireplumber.conf.d/)

Make sure you change the `node.name` to the appropriate value. Run `pw-cli info all | grep 'node.name = "alsa_output'` to get the `node.name`

# Uninstall instructions

run the following in terminal:

```
rm $HOME/.config/pipewire/pipewire.conf.d/convolver.conf
rm $HOME/.config/pipewire/game.wav
systemctl --user restart --now wireplumber pipewire pipewire-pulse
```

# Credits

uses game.wav from matte-schwartz's repo [here](https://github.com/matte-schwartz/device-quirks/blob/main/usr/share/device-quirks/scripts/asus/ally/pipewire/game.wav)
