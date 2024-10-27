#!/bin/bash

# Define your sinks
DEVICE1="alsa_output.pci-0000_0b_00.4.iec958-stereo"
DEVICE2="alsa_output.usb-iFi__by_AMR__iFi__by_AMR__HD_USB_Audio_0000-00.iec958-stereo"

# Get the script name
SCRIPT_NAME=$(basename $0)

# Find the PID of the running script (excluding the current instance)
RUNNING_PID=$(pgrep -f $SCRIPT_NAME | grep -v $$)

# If another instance is running, terminate it
if [ ! -z "$RUNNING_PID" ]; then
    kill $RUNNING_PID
fi

# Get the current default sink
CURRENT_SINK=$(pactl get-default-sink)

# Determine the next sink
if [ "$CURRENT_SINK" == "$DEVICE1" ]; then
    NEXT_SINK=$DEVICE2
else
    NEXT_SINK=$DEVICE1
fi

# Set the next sink as the default
pactl set-default-sink $NEXT_SINK

# Move all sink inputs to the new default sink, except Chromium
for INPUT in $(pactl list sink-inputs short | awk '{print $1}'); do
    APP_NAME=$(pactl list sink-inputs | grep -A 20 "Sink Input #$INPUT" | grep "application.name" | cut -d '"' -f 2)
    if [ "$APP_NAME" != "Chromium" ]; then
        pactl move-sink-input $INPUT $NEXT_SINK
        #echo "Moving: $APP_NAME" >> ~/togglescript.txt
    else
        # Move Discord back to the original sink
        pactl move-sink-input $INPUT $DEVICE2
        #echo "Discord!!! Making sure it stays on the Headphones." >> ~/togglescript.txt
    fi
done

# Ensure new applications use the new default sink
pactl subscribe | grep --line-buffered "sink-input" | while read -r event; do
    NEW_INPUT=$(echo $event | grep -oP '(?<=#)\d+')
    APP_NAME=$(pactl list sink-inputs | grep -A 20 "Sink Input #$NEW_INPUT" | grep "application.name" | cut -d '"' -f 2)
    if [ "$APP_NAME" != "Chromium" ] && [ -n "$APP_NAME" ]; then
        pactl move-sink-input $NEW_INPUT $NEXT_SINK
        #echo "New app detected. Moving: $APP_NAME" >> ~/togglescript.txt
    fi
done

#echo "- - - - - - - - - -" >> ~/togglescript.txt
