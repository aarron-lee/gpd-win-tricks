# Install instructions

run the following in terminal

```
curl -L https://raw.githubusercontent.com/aarron-lee/gpd-win-tricks/main/win4-gyro-suspend-fix/install.sh | sudo sh
```

# uninstall instructions

```
sudo systemctl disable --now gyro-resume-fix.service
sudo systemctl disable --now gyro-suspend-fix.service

sudo rm /usr/local/bin/suspend-mods
sudo rm /usr/local/bin/resume-mods

sudo rm /etc/systemd/system/gyro-resume-fix.service
sudo rm /etc/systemd/system/gyro-suspend-fix.service
```
