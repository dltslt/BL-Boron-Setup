#!/bin/bash

#echo "running X monitor script $(date)" >> /home/<user>/.local/monitor.log

# Get lid state
LID_STATE=$(cat /proc/acpi/button/lid/LID/state | awk '{print $2}')
EXTERNAL_OUTPUT="HDMI-1"  # adjust as needed
INTERNAL_OUTPUT="eDP-1"   # adjust as needed

# Get connected monitors
CONNECTED_OUTPUTS=$(xrandr --query | grep " connected" | awk '{print $1}')

#echo "LID_STATE: $LID_STATE" >> /home/<user>/.local/monitor.log
#echo "Connected Outputs: $CONNECTED_OUTPUTS" >> /home/<user>/.local/monitor.log

if [ "$LID_STATE" == "closed" ]; then
    if echo "$CONNECTED_OUTPUTS" | grep -q "$EXTERNAL_OUTPUT"; then
        # External monitor is connected, turn off internal and use external
        xrandr --output $INTERNAL_OUTPUT --off --output $EXTERNAL_OUTPUT --auto
#	echo "only external monitor" >> /home/<user>/.local/monitor.log
    else
        # No external monitor, just turn off internal screen
        xrandr --output $INTERNAL_OUTPUT --off
#	echo "no monitor, turning off internal" >> /home/<user>/.local/monitor.log
    fi
else
    # Lid open, enable both displays
    xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto --above $INTERNAL_OUTPUT
#    echo "dual monitor setup" >> /home/<user>/.local/monitor.log
fi
