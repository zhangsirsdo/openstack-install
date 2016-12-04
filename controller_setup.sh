#!/bin/bash

# Setup a controller node, including keystone, glance, nova, cinder, neutron.

# Init environ
sh repo.sh
sh controller_pkgs.sh

# Setup keystone
sh keystone_db.sh
sh keystone_install.sh
sh keystone_setup.sh

# Setup glance
sh glance_db.sh
sh glance_setup.sh
