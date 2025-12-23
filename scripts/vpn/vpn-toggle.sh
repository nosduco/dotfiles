#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
INTERFACE=$(wg show interfaces 2>/dev/null | head -1)

if [[ -n "$INTERFACE" ]]; then
    "$SCRIPT_DIR/vpn-down.sh"
else
    "$SCRIPT_DIR/vpn-up.sh"
fi
