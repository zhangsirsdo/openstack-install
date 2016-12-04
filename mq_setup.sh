#!/bin/bash

source $PWD/env.sh

# Install the package:
yum install -y rabbitmq-server

# Start the message queue service and configure it to start when the system boots:
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service

# Add the openstack user:
rabbitmqctl add_user openstack $RABBIT_PASS


#Permit configuration, write, and read access for the openstack user:
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

