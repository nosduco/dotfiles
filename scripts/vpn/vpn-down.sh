#!/bin/bash

CONFIG_DIR="$HOME/.dotfiles/wireguard/configs"
CACHE_DIR="$HOME/.cache/vpn"
CURRENT_FILE="$CACHE_DIR/current-server"

if [[ -f "$CURRENT_FILE" ]]; then
    SERVER=$(cat "$CURRENT_FILE")
    CONFIG="$CONFIG_DIR/$SERVER.conf"
else
    INTERFACE=$(wg show interfaces 2>/dev/null | head -1)
    if [[ -z "$INTERFACE" ]]; then
        dunstify -a "vpn" -u low "VPN" "Already disconnected"
        exit 0
    fi
    CONFIG="$INTERFACE"
fi

dunstify -a "vpn" -u normal "VPN" "Disconnecting..."
if sudo wg-quick down "$CONFIG" 2>/dev/null || sudo wg-quick down "$(wg show interfaces | head -1)" 2>/dev/null; then
    dunstify -a "vpn" -u normal "VPN Disconnected" ""
    rm -f "$CURRENT_FILE"
else
    dunstify -a "vpn" -u critical "VPN Error" "Failed to disconnect"
    exit 1
fi
