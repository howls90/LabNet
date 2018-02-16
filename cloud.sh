#!/bin/bash

# Check if Root
if ! [ $(id -u) = 0 ]; then
    echo "The script need to be run as root." >&2
    exit 1
fi

if [ -z "$1" ]
    then
    echo "No subnet provided, exemple: 1~254 number"
    exit 1
fi

# Check if input is number
if [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -ge 1 -a "$1" -le 254 ]
    then
    echo "Sorry integers from 1-254 only"
    exit 1
fi

PATH = $(pwd)

# Update repositories and install packages
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install git -y

# Create stack user
sudo useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack

# Devstack
sudo -u stack bash << EOF
git clone https://git.openstack.org/openstack-dev/devstack
cd devstack
mv $PATH/files/local.conf .
sed -i 's/20/$1/g' "local.conf"
./stack.sh
EOF

# Firewall configuration
sed -i -e '$i \sudo iptables -t nat -I POSTROUTING -o ib0 -s $1.0.0.0/24 -j MASQUERADE &\n' rc.local
sed -i -e '$i \sudo iptables -I FORWARD -s $1.0.0.0/24 -j ACCEPT &\n' rc.local
sed -i -e '$i \sudo iptables -I FORWARD -s 10.0.0.0/24 -j ACCEPT &\n' rc.local
sed -i -e '$i \sudo iptables -I FORWARD -s 192.168.5.0/24 -j ACCEPT &\n' rc.local
sudo echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i -e '$i \sudo ip route add 192.168.10.0/24 via 10.0.0.1 &\n' rc.local

# Install Zabbix
sudo apt-get install zabbix-agent
sed -i 's/Server=127.0.0.1/Server=192.168.5.30/g' "/etc/zabbix/zabbix_agentd.conf"
service zabbix-agent restart
