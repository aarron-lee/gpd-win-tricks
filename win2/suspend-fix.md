thanks to @wasokeli for this fix. See [#15](https://github.com/aarron-lee/gpd-win-tricks/issues/15) for original source


With a clean Bazzite install on a GPD Win 2, in Gaming Mode, selecting Power > Sleep results in the screen turning off for 15-30 seconds, then turning back on again. The fan never turns off. The problem doesn't occur in Desktop Mode.

After trying a few different things, disabling the touch screen fixes sleep:

```
/usr/sbin/modprobe -r goodix_ts
```

And enabling the touch screen breaks sleep again:

```
/usr/sbin/modprobe goodix_ts
```

As a workaround, this LLM-created service disables the touch screen on sleep, and enables it on wake. Place it in `/etc/systemd/system/goodix-suspend.service`, then restart:
```service
[Unit]
Description=Disable Goodix touchscreen before suspend
Before=sleep.target suspend.target
StopWhenUnneeded=yes

[Service]
Type=oneshot
ExecStart=/usr/sbin/modprobe -r goodix_ts
ExecStop=/usr/sbin/modprobe goodix_ts
RemainAfterExit=yes

[Install]
WantedBy=sleep.target
```
