#!/bin/sh
swaylock --screenshots  \
  --clock \
  --timestr "%-I:%M %p" \
  --indicator \
  --indicator-radius 100 \
  --indicator-thickness 7 \
  --effect-blur 7x5 \
  --effect-pixelate 1 \
  --effect-vignette 0.5:0.5 \
  --ring-color 1f2430 \
  --key-hl-color e95420 \
  --line-color 00000000 \
  --inside-color 00000088 \
  --separator-color 00000000 \
  --grace 2 \
  --fade-in 0.2 \
  -f
