#!/bin/bash

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals
#
# NOTE: this script uses bash (not POSIX shell) for the RANDOM variable
#
# Send USR1 signal to skip to next wallpaper immediately:
#   kill -USR1 $(pgrep -f wallpaper-random.sh)

if [[ $# -lt 1 ]] || [[ ! -d $1   ]]; then
	echo "Usage:
	$0 <dir containing images>"
	exit 1
fi

# Trap USR1 signal to kill sleep and skip to next wallpaper
trap 'kill $SLEEP_PID 2>/dev/null' USR1

INTERVAL=3600
wallpaper=""

while true; do
	# Store old wallpaper for cleanup
	old_wallpaper="$wallpaper"

	# Pick new random wallpaper
	wallpaper="$(find -L "$1" -maxdepth 1 -type f | shuf -n 1)"

	# Preload new wallpaper
	hyprctl hyprpaper preload "$wallpaper"

	# Set wallpaper on all monitors
	if [[ $(hostname) == "voyager" ]]; then
		hyprctl hyprpaper wallpaper "eDP-1,$wallpaper"
	else
		hyprctl hyprpaper wallpaper "DP-1,$wallpaper"
		hyprctl hyprpaper wallpaper "HDMI-A-1,$wallpaper"
		hyprctl hyprpaper wallpaper "DP-2,$wallpaper"
	fi

	# Unload old wallpaper AFTER switching to new one
	if [[ -n "$old_wallpaper" ]]; then
		hyprctl hyprpaper unload "$old_wallpaper"
	fi

	# Sleep but allow interruption by USR1 signal
	sleep $INTERVAL &
	SLEEP_PID=$!
	wait $SLEEP_PID
done
