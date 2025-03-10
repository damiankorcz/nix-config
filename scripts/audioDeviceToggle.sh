#!/bin/bash

# Define your sinks
DEVICE1="alsa_output.pci-0000_0d_00.4.iec958-stereo"
DEVICE2="alsa_output.usb-iFi__by_AMR__iFi__by_AMR__HD_USB_Audio_0000-00.iec958-stereo"

# Lock file
LOCKFILE="/tmp/audioDeviceToggle.lock"

# Create a lock file to prevent multiple instances
exec 200>$LOCKFILE
flock -n 200 || exit 1

# Kill previous instances of pactl subscribe, excluding the current one
pgrep -f "pactl subscribe" | grep -v $$ | xargs -r kill

# Get the current default sink
CURRENT_SINK=$(pactl get-default-sink)

# Determine the next sink
if [ "$CURRENT_SINK" == "$DEVICE1" ]; then
    NEXT_SINK=$DEVICE2
else
    NEXT_SINK=$DEVICE1
fi

# Set the next sink as the default
pactl set-default-sink "$NEXT_SINK"

# Move all existing sink inputs to the new default sink, except the specified applications
for INPUT in $(pactl list sink-inputs short | awk '{print $1}'); do
    PROCESS_NAME=$(pactl list sink-inputs | grep -A 20 "Sink Input #$INPUT" | grep "application.process.binary" | cut -d '"' -f 2)
    if [[ ! "$PROCESS_NAME" =~ "Discord" && ! "$PROCESS_NAME" =~ "DiscordCanary" ]]; then
        pactl move-sink-input "$INPUT" "$NEXT_SINK"
    fi
done

# Monitor for new sink inputs and move them to the new default sink, except the specified applications
(pactl subscribe | grep --line-buffered "sink-input" | while read -r event; do
    if echo "$event" | grep -q "new"; then
        NEW_INPUT=$(echo "$event" | grep -oP '(?<=#)\d+')
        PROCESS_NAME=$(pactl list sink-inputs | grep -A 20 "Sink Input #$NEW_INPUT" | grep "application.process.binary" | cut -d '"' -f 2)
        if [[ ! "$PROCESS_NAME" =~ "Discord" && ! "$PROCESS_NAME" =~ "DiscordCanary" ]]; then
            pactl move-sink-input "$NEW_INPUT" "$NEXT_SINK"
        fi
    fi
done) &

# Release the lock
flock -u 200
rm -f $LOCKFILE