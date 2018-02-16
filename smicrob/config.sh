#!/bin/bash

# Check if Root
if ! [ $(id -u) = 0 ]; then
    echo "The script need to be run as root." >&2
    exit 1
fi

# Update repositories and install packages
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install git -y

# Create stack user
sudo useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack

# Firewall configuration
sed -i -e '$i \sudo iptables -t nat -I POSTROUTING -o ib0 -s 30.0.0.0/24 -j MASQUERADE &\n' /etc/rc.local
sed -i -e '$i \sudo iptables -I FORWARD -s 30.0.0.0/24 -j ACCEPT &\n' /etc/rc.local
sed -i -e '$i \sudo iptables -I FORWARD -s 10.0.0.0/24 -j ACCEPT &\n' /etc/rc.local
sed -i -e '$i \sudo iptables -I FORWARD -s 192.168.5.0/24 -j ACCEPT &\n' /etc/rc.local
sed -i -e '$i \sudo ip route add 192.168.10.0/24 via 10.0.0.1 &\n' /etc/rc.local

sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -I POSTROUTING -o ib0 -s 30.0.0.0/24 -j MASQUERADE
sudo iptables -I FORWARD -s 30.0.0.0/24 -j ACCEPT
sudo iptables -I FORWARD -s 10.0.0.0/24 -j ACCEPT
sudo iptables -I FORWARD -s 192.168.5.0/24 -j ACCEPT
sudo ip route add 192.168.10.0/24 via 10.0.0.1

# Install Zabbix
sudo apt-get install zabbix-agent
sed -i 's/Server=127.0.0.1/Server=192.168.5.30/g' "/etc/zabbix/zabbix_agentd.conf"
service zabbix-agent restart
