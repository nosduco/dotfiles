#!/bin/bash
COLOR=${1:-FF2300}
echo Setting colors for Corsair AIO Cooler
liquidctl set led color fixed $COLOR
echo Setting colors for Razer Mamba Elite Mouse
openrgb --device $(openrgb --list-devices | grep "Razer Mamba Elite" | cut -c1-1) --mode static --color $COLOR
echo Setting colors for MSI 2080 Super
openrgb --device $(openrgb --list-devices | grep "MSI GeForce RTX 2080 Super Gaming X Trio" | cut -c1-1) --mode static --color $COLOR
echo Done!
