#!/usr/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. use sudo" >&2
    exit 1
fi

cd /tmp

git clone https://github.com/aarron-lee/gpd-win-tricks.git

cd gpd-win-tricks/win4-gyro-suspend-fix

cat <<EOF > "/etc/device-quirks/systemd-suspend-mods.conf"
bmi260_i2c
bmi260_core
EOF


cp ./suspend-mods.sh /usr/local/bin/suspend-mods
cp ./resume-mods.sh /usr/local/bin/resume-mods

chmod +x /usr/local/bin/suspend-mods
chmod +x /usr/local/bin/resume-mods

chcon -u system_u -r object_r --type=bin_t /usr/local/bin/suspend-mods
chcon -u system_u -r object_r --type=bin_t /usr/local/bin/resume-mods

cp gyro-resume-fix.service /etc/systemd/system
cp gyro-suspend-fix.service /etc/systemd/system

systemctl daemon-reload
systemctl enable --now gyro-resume-fix.service
systemctl enable --now gyro-suspend-fix.service

echo "installation complete!"

rm -rf /tmp/gpd-win-tricks
