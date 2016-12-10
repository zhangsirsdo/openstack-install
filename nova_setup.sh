#!/bin/bash

source $PWD/env.sh
source $PWD/admin-openrc.sh

# Create the nova user
openstack user create --domain default --password $NOVA_PASS  nova

# Add the admin role to the nova user:
openstack role add --project service --user nova admin

# Create the nova service entity:
openstack service create --name nova --description "OpenStack Compute" compute

# Create the Compute service API endpoints:
openstack endpoint create --region RegionOne \
        compute public http://controller:8774/v2.1/%\(tenant_id\)s
openstack endpoint create --region RegionOne \
        compute internal http://controller:8774/v2.1/%\(tenant_id\)s
openstack endpoint create --region RegionOne \
          compute admin http://controller:8774/v2.1/%\(tenant_id\)s


# config

# database
openstack-config --set /etc/nova/nova.conf api_database connection "mysql+pymysql://nova:$NOVA_DBPASS@localhost/nova_api"
openstack-config --set /etc/nova/nova.conf database connection "mysql+pymysql://nova:$NOVA_DBPASS@localhost/nova"

# rabbit
openstack-config --set /etc/nova/nova.conf DEFAULT rpc_backend "rabbit"
openstack-config --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_host "controller"
openstack-config --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_userid "openstack"
openstack-config --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_password "$RABBIT_PASS"

# keystone
openstack-config --set /etc/nova/nova.conf DEFAULT auth_strategy "keystone"
openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_uri "http://controller:5000"
openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_url "http://controller:35357"
openstack-config --set /etc/nova/nova.conf keystone_authtoken memcached_servers "controller:11211"
openstack-config --set /etc/nova/nova.conf keystone_authtoken auth_type "password"
openstack-config --set /etc/nova/nova.conf keystone_authtoken project_domain_name "default"
openstack-config --set /etc/nova/nova.conf keystone_authtoken user_domain_name "default"
openstack-config --set /etc/nova/nova.conf keystone_authtoken project_name "service"
openstack-config --set /etc/nova/nova.conf keystone_authtoken username "nova"
openstack-config --set /etc/nova/nova.conf keystone_authtoken password "$NOVA_PASS"

# networking
openstack-config --set /etc/nova/nova.conf DEFAULT my_ip `getent hosts controller | awk '{ print $1 }'`
openstack-config --set /etc/nova/nova.conf DEFAULT use_neutron "True"
openstack-config --set /etc/nova/nova.conf DEFAULT firewall_driver "nova.virt.firewall.NoopFirewallDriver"

# vnc
openstack-config --set /etc/nova/nova.conf vnc vncserver_listen "controller"
openstack-config --set /etc/nova/nova.conf vnc vncserver_proxyclient_address "controller"

# glance
openstack-config --set /etc/nova/nova.conf glance api_servers "http://controller:9292"

# misc
openstack-config --set /etc/nova/nova.conf oslo_concurrency lock_path "/var/lib/nova/tmp"

# Populate the Compute databases:
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage db sync" nova


# Start the Compute services and configure them to start when the system boots:

systemctl enable openstack-nova-api.service \
          openstack-nova-consoleauth.service openstack-nova-scheduler.service \
          openstack-nova-conductor.service openstack-nova-novncproxy.service
systemctl start openstack-nova-api.service \
          openstack-nova-consoleauth.service openstack-nova-scheduler.service \
          openstack-nova-conductor.service openstack-nova-novncproxy.service
