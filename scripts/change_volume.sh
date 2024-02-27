#!/bin/bash
# Helper functions
get_volume_integer() {
  local raw_volume=$(echo "$1" | awk '{print $2}')
  if [[ $raw_volume == "1.00" ]]; then
    echo 100
  elif [[ $raw_volume == "0.00" ]]; then
    echo 0
  else
    echo "$raw_volume" | awk -F'.' '{print $2}'
  fi
}

# Check arguments
if [ -z "$1" ]; then
  echo "Expected argument to be one of: [decrease, increase, mute]"
  exit 1
fi

# Track previous volume
PREVIOUS_VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

# Increase or decrease volume
if [ $1 = "increase" ]; then
  wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
elif [ $1 = "decrease" ]; then
  wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-
elif [ $1 = "mute" ]; then
  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
fi

# Get current volume
CURRENT_VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

# Check if mute
if [[ $(wpctl get-volume @DEFAULT_AUDIO_SINK@) == *"MUTED"* ]]; then
  # Display muted
  dunstify -a "volume" -u low -i audio-volume-muted -h string:x-dunst-stack-tag:volume "Volume muted!" 
elif [[ $PREVIOUS_VOLUME == *"MUTED"* ]]; then
  # Display unmuted
  dunstify -a "volume" -u low -i audio-volume-high -h string:x-dunst-stack-tag:volume "Volume unmuted:" -h int:value:$(get_volume_integer "$CURRENT_VOLUME")
elif [ $(get_volume_integer "$PREVIOUS_VOLUME") != $(get_volume_integer "$CURRENT_VOLUME") ]; then
  # Display volume change
  echo "test $(get_volume_integer "$CURRENT_VOLUME")"
  dunstify -a "volume" -u low -i audio-volume-high -h string:x-dunst-stack-tag:volume "Volume: " -h int:value:$(get_volume_integer "$CURRENT_VOLUME")
  # Play volume change sound
  canberra-gtk-play -i audio-volume-change -d "volume"
fi 

