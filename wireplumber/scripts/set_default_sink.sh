#!/bin/bash

# $HEADPHONES_ID=$(wpctl status | grep -m 1 -A 2 "Sinks" | grep "Headphones" | sed 's/[^0-9]*\([0-9]*\).*/\1/')
if [ -z "$1" ]; then
  echo "Expected argument to be one of: [headphones, speakers]"
elif [ $1 = "headphones" ]; then
  wpctl set-default $(wpctl status | grep -m 1 -A 2 "Sinks" | grep "Headphones" | sed 's/[^0-9]*\([0-9]*\).*/\1/')
  notify-send --icon=/usr/share/icons/Adwaita/512x512/devices/audio-headphones.png "Headphones set as default output device."
elif [ $1 = "speakers" ]; then
  wpctl set-default $(wpctl status | grep -m 1 -A 2 "Sinks" | grep "Speakers" | sed 's/[^0-9]*\([0-9]*\).*/\1/')
  notify-send --icon=/usr/share/icons/Numix/64@2x/devices/audio-speakers.svg "Speakers set as default output device."
fi


