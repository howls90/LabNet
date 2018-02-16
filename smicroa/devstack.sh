#!/bin/bash

# Devstack
git clone https://git.openstack.org/openstack-dev/devstack
mv local.conf devstack
cd devstack
./stack.sh



