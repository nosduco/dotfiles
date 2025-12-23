#!/bin/bash

CONFIG_DIR="$HOME/.dotfiles/wireguard/configs"
DEFAULT_FILE="$HOME/.dotfiles/wireguard/default-server"
CACHE_DIR="$HOME/.cache/vpn"

SERVER="${1:-$(cat "$DEFAULT_FILE" 2>/dev/null || echo "proton-us")}"
CONFIG="$CONFIG_DIR/$SERVER.conf"

if [[ ! -f "$CONFIG" ]]; then
    dunstify -a "vpn" -u critical "VPN Error" "Config not found: $SERVER"
    exit 1
fi

CURRENT=$(wg show interfaces 2>/dev/null | head -1)
if [[ -n "$CURRENT" ]]; then
    dunstify -a "vpn" -u normal "VPN" "Disconnecting from $CURRENT..."
    sudo wg-quick down "$CONFIG_DIR/$CURRENT.conf" 2>/dev/null || sudo wg-quick down "$CURRENT" 2>/dev/null
fi

mkdir -p "$CACHE_DIR"
ip route | grep "^default" > "$CACHE_DIR/original-gateway"

dunstify -a "vpn" -u normal "VPN" "Connecting to $SERVER..."
if sudo wg-quick up "$CONFIG"; then
    # Fix novpn namespace routing - wg-quick uses decreasing priorities
    WG_PRIO=$(ip rule show | grep "not from all fwmark" | awk -F: '{print $1}' | head -1)
    if [[ -n "$WG_PRIO" ]] && ip netns list 2>/dev/null | grep -q "^novpn"; then
        NS_IP="10.200.200.2"
        NEW_PRIO=$((WG_PRIO - 1))
        sudo ip rule del from "$NS_IP" lookup main 2>/dev/null || true
        sudo ip rule add from "$NS_IP" lookup main priority "$NEW_PRIO"
    fi
    dunstify -a "vpn" -u normal "VPN Connected" "Server: $SERVER"
    echo "$SERVER" > "$CACHE_DIR/current-server"
else
    dunstify -a "vpn" -u critical "VPN Error" "Failed to connect to $SERVER"
    exit 1
fi
