#!/bin/bash

source /home/config.sh
source /home/env.sh
source /home/os-openrc.sh
sh /home/keystone_install.sh
sh /home/keystone_setup.sh
source /home/admin-openrc.sh
unset OS_TOKEN
