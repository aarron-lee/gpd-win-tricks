#!/bin/bash
# This file runs during sleep/resume events. 
# Originally created by ChimeraOS

modprobe -r bmi260_i2c
modprobe -r bmi260_core
