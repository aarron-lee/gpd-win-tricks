Credit to @BrotherChenwk on the GPD Discord for this

## Win Mini EQ

### Install Instructions

1. set your volume to 100% before you continue
2. run the following in terminal:

```bash
mkdir -p $HOME/.config/pipewire/pipewire.conf.d/

curl -L "https://github.com/aarron-lee/gpd-win-tricks/raw/main/win_mini_equalizer/sink-eq10.conf" -o $HOME/.config/pipewire/pipewire.conf.d/sink-eq10.conf

systemctl --user restart wireplumber pipewire pipewire-pulse
```

3. Go back to game mode, go to settings -> audio, make sure the output is pointing to “GPD win mini EQ”

Disclaimer from @BrotherChenwk: By no means in any way I’m an audiophile or professional/learned enough for eq tuning but this should sound good enough on win mini 23/24, at least at 40% it’s more audible to me as opposed to stock settings in bazzite, and Justin’s profile
