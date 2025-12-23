#!/bin/bash

CACHE_DIR="$HOME/.cache/vpn"
INTERFACE=$(wg show interfaces 2>/dev/null | head -1)

ICON_CONNECTED="<span font='Material Design Icons' size='large' font_weight='normal' rise='-1500'>󰌾</span>"
ICON_DISCONNECTED="<span font='Material Design Icons' size='large' font_weight='normal' rise='-1500'>󰈂</span>"

if [[ -n "$INTERFACE" ]]; then
    SERVER=$(cat "$CACHE_DIR/current-server" 2>/dev/null || echo "$INTERFACE")

    STATS=$(wg show "$INTERFACE" transfer 2>/dev/null | head -1)
    if [[ -n "$STATS" ]]; then
        RX_BYTES=$(echo "$STATS" | awk '{print $2}')
        TX_BYTES=$(echo "$STATS" | awk '{print $3}')
        RX=$(numfmt --to=iec "$RX_BYTES" 2>/dev/null || echo "${RX_BYTES}B")
        TX=$(numfmt --to=iec "$TX_BYTES" 2>/dev/null || echo "${TX_BYTES}B")
    else
        RX="0"
        TX="0"
    fi

    ENDPOINT=$(wg show "$INTERFACE" endpoints 2>/dev/null | awk '{print $2}' | cut -d: -f1 | head -1)

    HANDSHAKE=$(wg show "$INTERFACE" latest-handshakes 2>/dev/null | awk '{print $2}' | head -1)
    if [[ -n "$HANDSHAKE" && "$HANDSHAKE" != "0" ]]; then
        HANDSHAKE_AGO=$(( $(date +%s) - HANDSHAKE ))
        if [[ $HANDSHAKE_AGO -lt 60 ]]; then
            HANDSHAKE_STR="${HANDSHAKE_AGO}s ago"
        elif [[ $HANDSHAKE_AGO -lt 3600 ]]; then
            HANDSHAKE_STR="$((HANDSHAKE_AGO / 60))m ago"
        else
            HANDSHAKE_STR="$((HANDSHAKE_AGO / 3600))h ago"
        fi
    else
        HANDSHAKE_STR="waiting..."
    fi

    TOOLTIP="Server: $SERVER\\nEndpoint: $ENDPOINT\\nRX: $RX / TX: $TX\\nHandshake: $HANDSHAKE_STR"

    echo "{\"text\":\"$ICON_CONNECTED\", \"alt\":\"connected\", \"tooltip\":\"$TOOLTIP\", \"class\":\"connected\"}"
else
    echo "{\"text\":\"$ICON_DISCONNECTED\", \"alt\":\"disconnected\", \"tooltip\":\"VPN Disconnected\", \"class\":\"disconnected\"}"
fi
