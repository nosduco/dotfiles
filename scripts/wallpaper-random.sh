#!/bin/bash

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals
#
# NOTE: this script uses bash (not POSIX shell) for the RANDOM variable

if [[ $# -lt 1 ]] || [[ ! -d $1   ]]; then
	echo "Usage:
	$0 <dir containing images>"
	exit 1
fi

INTERVAL=3600

while true; do
	wallpaper="$(find -L "$1" -type f -maxdepth 1 | shuf -n 1)"
	hyprctl hyprpaper preload "$wallpaper"

  if [[ $(hostname) == "voyager" ]]; then
	  hyprctl hyprpaper wallpaper "eDP-1,$wallpaper"
  else
	  hyprctl hyprpaper wallpaper "DP-1,$wallpaper"
	  hyprctl hyprpaper wallpaper "HDMI-A-1,$wallpaper"
  	hyprctl hyprpaper wallpaper "DP-2,$wallpaper"
  fi

	sleep $INTERVAL

	hyprctl hyprpaper unload "$wallpaper"
done
