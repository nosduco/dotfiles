# VPN (tailscale exit node) toggle for waybar. The NetworkManager
# dispatcher in hosts/voyager/network.nix picks the exit node on every
# connect and pauses it behind captive portals; this shows the result
# and lets it be flipped by hand. HOME_UUID is the nosnet profile UUID.

REFRESH=(--user kill --kill-whom=main -s SIGRTMIN+9 waybar)

exit_node() {
  tailscale status --json | jq -r '
    select(.BackendState == "Running" and .ExitNodeStatus != null)
    | [.Peer[]? | select(.ExitNode) | "\(.HostName) (\(.Location.City // "unknown"))"][0] // "unknown"'
}

home() {
  nmcli -t -f UUID connection show --active | grep -x "$HOME_UUID" >/dev/null
}

emit() {
  jq -nc --arg alt "$1" --arg tooltip "$2" '{alt: $alt, class: $alt, tooltip: $tooltip}'
}

case "${1:-}" in
  status)
    node=$(exit_node || true)
    if [ -n "$node" ]; then
      emit on "VPN on: $node"
    elif home; then
      emit home "VPN off: home network"
    elif [ "$(nmcli networking connectivity)" = portal ]; then
      emit portal "VPN paused: Wi-Fi login page. Log in, then click to turn the VPN back on"
    else
      emit exposed "VPN off: not on home network"
    fi
    ;;
  toggle)
    if [ -n "$(exit_node || true)" ]; then
      tailscale set --exit-node=
    else
      tailscale set --exit-node=auto:any
    fi
    systemctl "${REFRESH[@]}"
    ;;
  *)
    echo "usage: $0 {toggle|status}" >&2
    exit 1
    ;;
esac
