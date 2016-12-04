#!/bin/bash

source $PWD/env.sh

# Install the packages:

yum install -y memcached python-memcached

# Start the Memcached service and configure it to start when the system boots:

systemctl enable memcached.service
systemctl start memcached.service
