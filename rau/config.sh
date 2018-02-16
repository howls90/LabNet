#!/bin/bash

# Check if Root
if ! [ $(id -u) = 0 ]; then
    echo "The script need to be run as root." >&2
    exit 1
fi

sudo ip route add 20.0.0.0/24 dev 10.0.0.2 ib0
sudo ip route add 30.0.0.0/24 dev 10.0.0.3 ib0
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -I FORWARD -s 192.168.10.0/24 -j ACCEPT

sed -i -e '$i \sudo ip route add 20.0.0.0/24 dev 10.0.0.2 ib0 &\n' /etc/rc.local
sed -i -e '$i \sudo ip route add 30.0.0.0/24 dev 10.0.0.3 ib0 &\n' /etc/rc.local
sed -i -e '$i \sudo iptables -I FORWARD -s 192.168.10.0/24 -j ACCEPT &\n' /etc/rc.local
