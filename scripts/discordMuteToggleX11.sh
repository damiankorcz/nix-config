#!/bin/bash

# Get the ID of the currently focused window
initial_window=$(xdotool getwindowfocus)

# Find all window IDs of the windows matching "vesktop"
vesktop_windows=$(xdotool search --onlyvisible --class "vesktop")

# Check if any "vesktop" windows were found
if [ -n "$vesktop_windows" ]; then
    # Loop through each window ID and send Ctrl+Shift+M
    for window in $vesktop_windows; do
        xdotool windowactivate --sync $window key Ctrl+Shift+M
    done

    # Return to the initially focused window
    xdotool windowactivate $initial_window
fi
