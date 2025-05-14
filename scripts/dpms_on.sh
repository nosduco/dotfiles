#!/bin/bash
hyprctl dispatch dpms on DP-2
sleep 1
hyprctl dispatch dpms on DP-1
sleep 2
for i in {1..3}; do
  hyprctl dispatch dpms on HDMI-A-1
  sleep 1
done
# sleep 1
# hyprctl dispatch dpms on
# hyprctl dispatch dpms on HDMI-A-1
