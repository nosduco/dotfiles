#!/bin/bash

# Skip to next wallpaper by sending signal to wallpaper-random.sh

# Check if wallpaper script is running
if ! pgrep -f "wallpaper-random.sh" > /dev/null; then
	notify-send "Wallpaper" "Wallpaper script not running" -u low
	exit 1
fi

# Send signal to all matching processes (in case of duplicates)
pkill -USR1 -f "wallpaper-random.sh"
notify-send "Wallpaper" "Switching to next wallpaper..." -u low -t 2000
