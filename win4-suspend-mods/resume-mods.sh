#!/bin/bash
# This file runs during sleep/resume events.
# Originally created by ChimeraOS

modprobe bmi160_i2c
modprobe bmi160_core

modprobe bmi260_i2c
modprobe bmi260_core

modprobe bmi270_i2c
modprobe bmi270_core
