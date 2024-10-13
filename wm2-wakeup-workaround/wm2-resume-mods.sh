#!/bin/bash

# source: https://github.com/SpookOz/spook-wm2/blob/main/wakeup-script.sh
# all credit goes to the original dev

# modified for to use as a systemd service, which is friendly to atomic/read-only root distros like Bazzite and ChimeraOS

# WM2 Suspend script v6 - 121024

#------------------------------------------------------#
# This script is intended to work around the WM2 2024 issue where the device will wake from sleep after losing 5% battery.
# It will run as soon as the device wakes from suspend and check if the lid is closed. If the lid is closed, the script will put the device back to sleep.

# NB: The script will log its actions to the system journal with the tag: SleepPatch. To check, run the command: sudo journalctl -b | grep "SleepPatch"
# NB: If you try to wake your device while the lid is closed (eg with external screen attached) this script will put it back to sleep immediately.
# So if you work with your screen closed, this script is probably not for you.
#------------------------------------------------------#

# Variables
sleeptime=60

# Function to cancel suspend and log
cancel_suspend() {
    logger "SleepPatch: Cancelling suspend cycle..."
    systemctl stop suspend.target
    systemctl stop sleep.target
}

# Function to check if the system is still in a suspend cycle
check_suspend_status() {
    local max_attempts=12
    local attempt=0

    # Loop until suspend.target is inactive or the max_attempts is reached
    while systemctl is-active --quiet suspend.target; do
        if [ "$attempt" -ge "$max_attempts" ]; then
            logger "SleepPatch: Halting script as system has reported that it is still in suspend too many times..."
            return 1
        fi
        logger "SleepPatch: Suspend is still in progress, waiting... (Attempt $((attempt+1)) of $max_attempts)"
        sleep 10
        attempt=$((attempt+1))
    done

    return 0
}

# Main logic

logger "SleepPatch: ---start wm2 resume mods---"

# Check the lid state first, exit if open
lid_state=$(cat /proc/acpi/button/lid/*/state | awk '{print $2}')
if [ -z "$lid_state" ]; then
	logger "SleepPatch: Unable to determine lid state. Exiting script."
	exit 1
elif [ "$lid_state" = "open" ]; then
	logger "SleepPatch: Lid is open. Nothing to do."
	exit 0
else
	logger "SleepPatch: Lid is closed. Proceeding with suspend checks..."
fi

# Wait for sleep cycle to finish
logger "SleepPatch: Sleeping $sleeptime seconds to wait for system to wake fully."
sleep $sleeptime


logger "SleepPatch: Running post-suspend checks."

# Check if the system is still in the middle of a suspend cycle
if ! check_suspend_status; then
    # Exit the script if the suspend status was checked too many times
    exit 1
fi

logger "SleepPatch: Checking for suspend inhibitors."
if ! systemctl list-jobs | grep -q 'suspend.target'; then
    lid_state=$(cat /proc/acpi/button/lid/*/state | awk '{print $2}')
    # check lid state one more time, just in case
    if [ "$lid_state" = "open" ]; then
        logger "SleepPatch: Lid is open. Nothing to do."
        exit 0
    fi
    logger "SleepPatch: No suspend inhibitors found and lid is still closed. Putting the system back to sleep."
    systemctl suspend
else
    logger "SleepPatch: Another suspend cycle is in progress, skipping."
fi
