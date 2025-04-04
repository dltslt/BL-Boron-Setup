#!/bin/bash

#echo "running lightdm monitor script $(date):" >> /home/<user>/.local/monitor.log

LID_STATE=$(cat /proc/acpi/button/lid/LID/state | awk '{print $2}')
EXTERNAL_OUTPUT="HDMI-1"  # adjust as needed
INTERNAL_OUTPUT="eDP-1"   # adjust as needed

CONNECTED_OUTPUTS=$(xrandr --query | grep " connected" | awk '{print $1}')

if [ "$LID_STATE" == "closed" ]; then
    if echo "$CONNECTED_OUTPUTS" | grep -q "$EXTERNAL_OUTPUT"; then
        xrandr --output $INTERNAL_OUTPUT --off --output $EXTERNAL_OUTPUT --auto
#	echo "only external monitor" >> /home/<user>/.local/monitor.log
    else
        xrandr --output $INTERNAL_OUTPUT --off
#	echo "no external monitor, internal monitor off" >> /home/<user>/.local/monitor.log
    fi
else
    xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto --above $INTERNAL_OUTPUT
#    echo "dual monitor setup" >> /home/<user>/.local/monitor.log
fi
