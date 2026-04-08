#!/bin/bash
# Apply persistent DualSense lightbar/player-LED state.
# Called from two places:
#   - /etc/udev/rules.d/99-dualsense.rules on USB hotplug
#   - dualsense-persist.timer (periodic refresh, e.g. after a game overrides)
# Exits silently when no controller is bound, so the timer is a no-op
# while disconnected.
set -e

# Sysfs detection: any DualSense bound to the kernel `playstation` HID driver?
shopt -s nullglob
bound=(/sys/bus/hid/drivers/playstation/*054C:0CE6*)
[ ${#bound[@]} -gt 0 ] || exit 0

# Settle: udev fires before the playstation driver finishes init; harmless
# on the periodic refresh path.
sleep 2

dualsensectl lightbar 255 80 0 255
dualsensectl player-leds 0
