#!/bin/bash
COLOR=${1:-FF2300}
echo Setting colors for Corsair AIO Cooler
liquidctl --match hydro set led color fixed $COLOR
echo Setting colors for MSI 2080 Super
openrgb --device $(openrgb --list-devices | grep "MSI GeForce RTX 2080 Super Gaming X Trio" | cut -c1-1) --mode static --color $COLOR
echo Setting colors for G703 Mouse
# openrgb --device $(openrgb --list-devices | grep "G703 LIGHTSPEED Wireless Gaming Mouse w/ HERO" | cut -c1-1) --mode static --color $COLOR
openrgb --device $(openrgb --list-devices | grep "G703 LIGHTSPEED Wireless Gaming Mouse w/ HERO" | cut -c1-1) --mode static --color EEE222
echo Done!
