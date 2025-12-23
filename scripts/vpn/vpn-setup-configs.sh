#!/bin/bash
# Import and patch ProtonVPN WireGuard configs for LAN bypass

CONFIG_DIR="$HOME/.dotfiles/wireguard/configs"
LAN_SUBNET="10.8.0.0/16"

mkdir -p "$CONFIG_DIR"

patch_config() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        echo "Error: File not found: $file"
        return 1
    fi

    if ! grep -q "\[Interface\]" "$file" || ! grep -q "\[Peer\]" "$file"; then
        echo "Warning: $file doesn't look like a WireGuard config, skipping"
        return 1
    fi

    echo "Patching: $(basename "$file")"

    sed -i "s|^AllowedIPs = .*|AllowedIPs = 0.0.0.0/0, ::/0|" "$file"
    sed -i '/^PostUp = .*# vpn-setup/d' "$file"
    sed -i '/^PostDown = .*# vpn-setup/d' "$file"

    local gw_cmd='$(ip route show default | awk '\''{print $3; exit}'\'')'
    local dev_cmd='$(ip route show default | awk '\''{print $5; exit}'\'')'
    sed -i "/^\[Peer\]/i PostUp = ip route add $LAN_SUBNET via $gw_cmd dev $dev_cmd # vpn-setup" "$file"
    sed -i "/^\[Peer\]/i PostDown = ip route del $LAN_SUBNET 2>/dev/null || true # vpn-setup" "$file"
}

import_config() {
    local src="$1"
    local filename=$(basename "$src")
    local clean_name=""

    # Extract country code from ProtonVPN naming
    # Interface names must be <=15 chars, so keep it short
    if [[ "$filename" =~ ^([A-Z]{2}) ]]; then
        local country="${BASH_REMATCH[1],,}"
        clean_name="proton-${country}.conf"
    else
        # Truncate to keep interface name under 15 chars
        local base="${filename%.conf}"
        base="${base:0:10}"
        clean_name="${base}.conf"
    fi

    local dest="$CONFIG_DIR/$clean_name"
    local counter=1
    while [[ -f "$dest" ]]; do
        local base="${clean_name%.conf}"
        dest="$CONFIG_DIR/${base}-${counter}.conf"
        ((counter++))
    done

    echo "Importing: $filename -> $(basename "$dest")"
    cp "$src" "$dest"
    patch_config "$dest"
}

if [[ $# -eq 0 ]]; then
    echo "Patching existing configs in $CONFIG_DIR..."
    count=0
    for conf in "$CONFIG_DIR"/*.conf; do
        [[ -f "$conf" ]] || continue
        patch_config "$conf"
        ((count++))
    done
    if [[ $count -eq 0 ]]; then
        echo ""
        echo "No configs found. Download from https://account.protonvpn.com"
        echo "Then run: vpn-setup-configs.sh /path/to/downloaded/configs/"
    else
        echo "Patched $count config(s)"
    fi
elif [[ -d "$1" ]]; then
    echo "Importing configs from: $1"
    count=0
    for conf in "$1"/*.conf; do
        [[ -f "$conf" ]] || continue
        import_config "$conf"
        ((count++))
    done
    echo "Imported $count config(s)"
elif [[ -f "$1" ]]; then
    import_config "$1"
else
    echo "Usage: vpn-setup-configs.sh [path]"
    exit 1
fi

echo ""
echo "Configs stored in: $CONFIG_DIR"
