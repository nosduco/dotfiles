#!/bin/bash

export MAIN_CONN=enp5s0
bash -x <<EOS
systemctl stop libvirtd
nmcli c delete "$MAIN_CONN"
nmcli c delete "Wired connection 1"
nmcli c delete "br0" || true
nmcli c delete "br0-slave" || true

nmcli c add type bridge ifname br0 autoconnect yes con-name br0 stp off
nmcli connection modify br0 ipv4.method auto ipv6.method ignore

nmcli c add type bridge-slave autoconnect yes con-name br0-slave ifname "$MAIN_CONN" master br0

systemctl restart NetworkManager
EOS
