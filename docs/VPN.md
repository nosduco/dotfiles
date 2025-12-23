# WireGuard VPN (ProtonVPN)

Custom VPN management with WireGuard, Waybar integration, and split tunneling.

## Setup

### 1. Generate configs

Install the config generator:

```bash
git clone https://github.com/hatemosphere/protonvpn-wg-config-generate /tmp/pwg
cd /tmp/pwg && make build
sudo mv build/protonvpn-wg-config-generate /usr/local/bin/
```

Generate configs (prompts for ProtonVPN login first time):

```bash
protonvpn-wg-config-generate -countries US,NL,CH -output ~/.dotfiles/wireguard/configs/
```

### 2. Patch configs for LAN bypass

```bash
~/.dotfiles/scripts/vpn/vpn-setup-configs.sh
```

This modifies `AllowedIPs` to exclude 10.x, 172.16.x, 192.168.x.

### 3. Install system files

```bash
cd ~/.dotfiles && ./install
```

### 4. Enable split tunneling

```bash
sudo systemctl enable --now vpn-netns.service
```

---

## Usage

**Waybar:** Left-click toggles, right-click opens server menu.

**Keybinds:**

- `Super+V` - Toggle VPN
- `Super+Shift+V` - Server menu

**CLI:**

```bash
vpn-up.sh proton-us     # Connect
vpn-down.sh             # Disconnect
vpn-toggle.sh           # Toggle
vpn-menu.sh             # Walker picker
```

**Run app outside VPN:**

```bash
novpn-exec steam
novpn-exec curl ifconfig.me  # Check real IP
```

---

## How it works

- `wg-quick` manages the WireGuard interface
- Waybar polls `vpn-status.sh` every 5s for connection state
- Split tunneling uses a network namespace (`novpn`) with veth pair back to host
- Apps in namespace route through original gateway, bypassing VPN

---

## Files

```
scripts/vpn/
├── vpn-up.sh / vpn-down.sh / vpn-toggle.sh
├── vpn-status.sh          # Waybar JSON
├── vpn-menu.sh            # Walker picker
├── vpn-setup-configs.sh   # Patch AllowedIPs
├── vpn-netns-setup.sh     # Create novpn namespace
└── novpn-exec.sh          # Run app outside VPN

wireguard/
├── configs/*.conf         # gitignored, private keys
└── default-server         # Default server name

system/
├── sudoers.d/wireguard    # Passwordless wg-quick
└── systemd/vpn-netns.service
```
