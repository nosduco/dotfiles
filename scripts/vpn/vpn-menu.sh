#!/bin/bash

CONFIG_DIR="$HOME/.dotfiles/wireguard/configs"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

SERVERS=""
for conf in "$CONFIG_DIR"/*.conf; do
    [[ -f "$conf" ]] || continue
    name=$(basename "$conf" .conf)
    SERVERS="${SERVERS}${name}\n"
done

INTERFACE=$(wg show interfaces 2>/dev/null | head -1)
if [[ -n "$INTERFACE" ]]; then
    SERVERS="[Disconnect]\n${SERVERS}"
fi

SELECTED=$(echo -e "$SERVERS" | walker --dmenu --placeholder "Select VPN Server...")

if [[ -n "$SELECTED" ]]; then
    if [[ "$SELECTED" == "[Disconnect]" ]]; then
        "$SCRIPT_DIR/vpn-down.sh"
    else
        "$SCRIPT_DIR/vpn-up.sh" "$SELECTED"
    fi
fi
