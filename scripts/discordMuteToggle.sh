#!/bin/bash

# Get the ID of the currently focused window
initial_window=$(kdotool getactivewindow)

# Find all window IDs of the windows matching "vesktop"
vesktop_windows=$(kdotool search --class "vesktop")

# Check if any "vesktop" windows were found
if [ -n "$vesktop_windows" ]; then
    # Loop through each window ID and send Ctrl+Shift+M
    for window in $vesktop_windows; do
        kdotool windowactivate $window
        ydotool key 29:1 42:1 50:1 50:0 42:0 29:0 # Ctrl+Shift+M
    done

    # Return to the initially focused window
    kdotool windowactivate $initial_window
fi
