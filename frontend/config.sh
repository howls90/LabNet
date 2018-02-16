#!/bin/bash

# Check if Root
if ! [ $(id -u) = 0 ]; then
    echo "The script need to be run as root." >&2
    exit 1
fi

sed -i -e '$i \sudo ip route add 20.0.0.0/24 via 192.168.5.31 &\n' /etc/rc.local
sed -i -e '$i \sudo ip route add 30.0.0.0/24 via 192.168.5.32 &\n' /etc/rc.local

sudo ip route add 20.0.0.0/24 via 192.168.5.31
sudo ip route add 30.0.0.0/24 via 192.168.5.32
