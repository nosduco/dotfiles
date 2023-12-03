#!/bin/bash

hyprctl dispatch dpms on
hyprctl dispatch workspace 1
hyprctl dispatch workspace top-monitor
hyprctl dispatch workspace right-monitor
swww init
