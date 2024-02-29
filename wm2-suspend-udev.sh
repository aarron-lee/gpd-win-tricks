#/bin/bash
#https://github.com/Cryolitia/nixos-config/blob/1ff4c1ea97313f59ee3cc051eb8481583033bdf0/hosts/gpd/default.nix#L67
#https://github.com/torvalds/linux/commit/805c74eac8cb306dc69b87b6b066ab4da77ceaf1

echo 'fix sleep on wm2'

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root, use sudo" >&2
    exit 1
fi

touch /etc/udev/rules.d/50-gpd-win-max.rules

cat <<EOF >> "/etc/udev/rules.d/50-gpd-win-max.rules"
ACTION=="add", SUBSYSTEM=="i2c", ATTR{name}=="PNP0C50:00", ATTR{power/wakeup}="disabled"
EOF

udevadm control --reload-rules
udevadm trigger

echo 'complete!'
