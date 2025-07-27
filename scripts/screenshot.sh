#!/bin/bash

OUTPUT_DIR="$HOME/Pictures/Screenshots/"

if [[ ! -d "$OUTPUT_DIR" ]]; then
  mkdir $OUTPUT_DIR
fi

pkill slurp || hyprshot -m ${1:-region} --raw |
  satty --filename - \
    --output-filename "$OUTPUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
    --early-exit \
    --actions-on-enter save-to-clipboard \
    --save-after-copy \
    --copy-command 'wl-copy'
