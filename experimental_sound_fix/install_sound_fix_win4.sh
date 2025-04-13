#!/usr/bin/bash
# Win 4 setup script
# does the following:
# - Modified Pipewire EQ fixes

# Notes:
# pw-cli info all | grep 'node.name = "alsa_output'
# wpctl status
# coppwr app
# qpwgraph app

# Ensure not running as root
if [ "$EUID" -eq 0 ]; then
    echo "This script must not be run as root." >&2
    exit 1
fi

echo "installing pipewire EQ sound improvements"
# download + setup pipewire EQ sound improvements

cd /tmp

git clone --depth=1 https://github.com/aarron-lee/gpd-win-tricks.git

cd /tmp/gpd-win-tricks/experimental_sound_fix

PIPEWIRE_DIR=$HOME/.config/pipewire
PIPEWIRE_CONF_DIR=$PIPEWIRE_DIR/pipewire.conf.d

mkdir -p $PIPEWIRE_DIR
mkdir -p $PIPEWIRE_CONF_DIR

cat << EOF > "$PIPEWIRE_CONF_DIR/convolver.conf"
# Convolver Configuration for Pipewire
#
# This configuration applies separate left and right convolver effects using the corresponding impulse response files
# to the entire system audio output.

context.modules = [
    { name = libpipewire-module-filter-chain
        args = {
            node.description = "GPD Win"
            media.name       = "GPD Win"
            filter.graph = {
                nodes = [
                    {
                        type  = builtin
                        label = convolver
                        name  = convFL
                        config = {
                            gain = 1.5
                            filename = "$HOME/.config/pipewire/game.wav"
                            channel  = 0
                        }
                    }
                    {
                        type  = builtin
                        label = convolver
                        name  = convFR
                        config = {
                            gain = 1.5
                            filename = "$HOME/.config/pipewire/game.wav"
                            channel  = 1
                        }
                    }
                ]
                inputs = [ "convFL:In" "convFR:In" ]
                outputs = [ "convFL:Out" "convFR:Out" ]
            }
            capture.props = {
                node.name      = "GPD Win"
                media.class    = "Audio/Sink"
                priority.driver = 1100
                priority.session = 1100
                audio.channels = 2
                audio.position = [ FL FR ]
            }
            playback.props = {
                node.name      = "GPD Win corrected"
                node.passive   = true
                audio.channels = 2
                audio.position = [ FL FR ]
                node.target = "alsa_output.pci-0000_73_00.6.analog-stereo"
            }
        }
    }
]
EOF

cp /tmp/gpd-win-tricks/experimental_sound_fix/game.wav $PIPEWIRE_DIR/game.wav

systemctl --user restart --now wireplumber pipewire pipewire-pulse

rm -rf /tmp/gpd-win-tricks

echo "Installation complete. Change your audio source to 'GPD Win'"

echo "-------------
READ THE FOLLOWING!
-------------"

echo "note that this fix itself is a bit odd.
the volume of your regular speakers affects the max volume of the 'GPD Win' sound option.
so basically install this fix, then max out/adjust audio volume on regular speakers, then swap to other audio source"
