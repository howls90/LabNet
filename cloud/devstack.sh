#!/bin/bash

if [ -z "$1" ]
    then
    echo "No subnet provided, exemple: 1~254 number"
    exit 1
fi

# Devstack
git clone https://git.openstack.org/openstack-dev/devstack
mv local.conf devstack
cd devstack
sed -i 's/20/$1/g' "local.conf"
./stack.sh



