#!/bin/bash
# This file runs during sleep/resume events. It will read the list of modules
# in /etc/device-quirks/systemd-suspend-mods.conf and rmmod them on suspend,
# insmod them on resume.
# Originally created by ChimeraOS

modprobe -r bmi260_i2c
modprobe -r bmi260_core
