#!/bin/bash
# Run command outside VPN tunnel

NAMESPACE="novpn"

if [[ $# -eq 0 ]]; then
    echo "Usage: novpn-exec <command> [args...]"
    exit 1
fi

if ! ip netns list 2>/dev/null | grep -q "^$NAMESPACE"; then
    dunstify -a "vpn" -u critical "NoVPN Error" "Namespace not set up"
    echo "Error: Namespace not found. Run: sudo vpn-netns-setup.sh"
    exit 1
fi

exec sudo ip netns exec "$NAMESPACE" \
    sudo -u "$USER" \
    env "HOME=$HOME" \
    "DISPLAY=${DISPLAY:-}" \
    "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-}" \
    "XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-}" \
    "DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS:-}" \
    "$@"
