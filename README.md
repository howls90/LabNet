# Lab Network

## Installation

### FrontEnd and RAU
```
sudo chmod 777 config.sh
sudo ./config.sh 
```
### Smicros
```
sudo chmod 777 config.sh
sudo ./config.sh
sudo su - stack
git clone https://github.com/howls90/LabNet.git
cd smicro
chmod 777 devstack
./devstack.sh
```

## Considerations
```
Frontend IP = 192.168.5.30
RAU IP = 10.0.0.1
Zabbix Server IP = 192.168.5.30
Frontend-Cloud Net = 192.168.5.0/24
Cloud-RAU Net = 10.0.0.0/24
USRPs Net = 192.168.0.0/16
Clouds public interface = ib0
```
