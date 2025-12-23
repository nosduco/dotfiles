#!/bin/bash
# Creates "novpn" namespace that bypasses VPN tunnel

set -e

NAMESPACE="novpn"
VETH_HOST="veth-novpn"
VETH_NS="veth-ns"
HOST_IP="10.200.200.1"
NS_IP="10.200.200.2"

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

if ip netns list | grep -q "^$NAMESPACE"; then
    echo "Namespace $NAMESPACE already exists"
    exit 0
fi

echo "Creating network namespace: $NAMESPACE"

# Use cached gateway if VPN is already up
# Try to find user's cache dir (logname fails in systemd context)
REAL_USER="${SUDO_USER:-$(logname 2>/dev/null || echo tony)}"
CACHE_DIR="/home/$REAL_USER/.cache/vpn"
if [[ -f "$CACHE_DIR/original-gateway" ]]; then
    DEFAULT_ROUTE=$(cat "$CACHE_DIR/original-gateway")
else
    DEFAULT_ROUTE=$(ip route | grep "^default" | head -1)
fi

DEFAULT_IF=$(echo "$DEFAULT_ROUTE" | awk '{print $5}')
DEFAULT_GW=$(echo "$DEFAULT_ROUTE" | awk '{print $3}')

if [[ -z "$DEFAULT_IF" ]] || [[ -z "$DEFAULT_GW" ]]; then
    echo "Error: Could not determine default interface and gateway"
    exit 1
fi

echo "Using interface: $DEFAULT_IF, gateway: $DEFAULT_GW"

ip netns add "$NAMESPACE"
ip netns exec "$NAMESPACE" ip link set lo up

ip link add "$VETH_HOST" type veth peer name "$VETH_NS"
ip link set "$VETH_NS" netns "$NAMESPACE"

ip addr add "$HOST_IP/30" dev "$VETH_HOST"
ip link set "$VETH_HOST" up

ip netns exec "$NAMESPACE" ip addr add "$NS_IP/30" dev "$VETH_NS"
ip netns exec "$NAMESPACE" ip link set "$VETH_NS" up
ip netns exec "$NAMESPACE" ip route add default via "$HOST_IP"

sysctl -w net.ipv4.ip_forward=1 > /dev/null

ip rule add from "$NS_IP" lookup main priority 10 2>/dev/null || true

iptables -t nat -C POSTROUTING -s "$NS_IP" -o "$DEFAULT_IF" -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING -s "$NS_IP" -o "$DEFAULT_IF" -j MASQUERADE

iptables -C FORWARD -i "$VETH_HOST" -o "$DEFAULT_IF" -j ACCEPT 2>/dev/null || \
    iptables -A FORWARD -i "$VETH_HOST" -o "$DEFAULT_IF" -j ACCEPT

iptables -C FORWARD -o "$VETH_HOST" -i "$DEFAULT_IF" -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || \
    iptables -A FORWARD -o "$VETH_HOST" -i "$DEFAULT_IF" -m state --state RELATED,ESTABLISHED -j ACCEPT

mkdir -p /etc/netns/"$NAMESPACE"
cat > /etc/netns/"$NAMESPACE"/resolv.conf << EOF
nameserver 1.1.1.1
nameserver 8.8.8.8
nameserver 9.9.9.9
EOF

echo "Namespace $NAMESPACE created"
echo "Use novpn-exec <command> to run commands outside VPN"
