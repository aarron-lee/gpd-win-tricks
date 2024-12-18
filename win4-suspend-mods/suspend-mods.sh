#!/bin/bash
# This file runs during sleep/resume events. 
# Originally created by ChimeraOS

modprobe -r bmi260_i2c
modprobe -r bmi260_core

# WM2?
#echo disabled | tee /sys/bus/i2c/devices/i2c-GXTP7385:00/power/wakeup
#echo disabled | tee /sys/bus/i2c/devices/i2c-PNP0C50:00/power/wakeup
