#!/bin/bash

# Check if Root
if ! [ $(id -u) = 0 ]; then
    echo "The script need to be run as root." >&2
    exit 1
fi

# Networking
sed -i -e '$i \sudo ip route add 20.0.0.0/24 via 192.168.5.31 &\n' /etc/rc.local
sed -i -e '$i \sudo ip route add 30.0.0.0/24 via 192.168.5.32 &\n' /etc/rc.local

sudo ip route add 20.0.0.0/24 via 192.168.5.31
sudo ip route add 30.0.0.0/24 via 192.168.5.32

# Apache 2
apt-get install apache2 -y
mv kibana.conf /etc/apache2/sites-available
mv oocran.conf /etc/apache2/sites-available
mv smicroa.conf /etc/apache2/sites-available
mv smicrob.conf /etc/apache2/sites-available
mv zabbix.conf /etc/apache2/sites-available
a2ensite kibana
a2ensite oocran
a2ensite smicroa
a2ensite smicrob
a2ensite zabbix

# Zabbix
sudo apt-get install php7.0-xml php7.0-bcmath php7.0-mbstring -y
wget http://repo.zabbix.com/zabbix/3.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.2-1+xenial_all.deb
sudo dpkg -i zabbix-release_3.2-1+xenial_all.deb
sudo apt-get install zabbix-server-mysql zabbix-frontend-php -y
sudo apt-get install zabbix-agent
mysql -u root -p odissey09 -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -u root -p odissey09 -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'odissey09';"
mysql -u root -p odissey09 -e "flush privileges;"

zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -uzabbix -p zabbix
mv zabbix_server.conf /etc/zabbix/
mv apache.conf /etc/zabbix/
sudo systemctl restart apache2
sudo systemctl start zabbix-server
sudo systemctl enable zabbix-server







