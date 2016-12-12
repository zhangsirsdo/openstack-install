#!/bin/bash

source $PWD/env.sh

### For Nova

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
openstack-config --set /etc/nova/nova.conf vnc enabled "True"
openstack-config --set /etc/nova/nova.conf vnc vncserver_listen "controller"
openstack-config --set /etc/nova/nova.conf vnc vncserver_proxyclient_address "controller"
openstack-config --set /etc/nova/nova.conf vnc novncproxy_base_url "http://controller:6080/vnc_auto.html"

# glance
openstack-config --set /etc/nova/nova.conf glance api_servers "http://controller:9292"

# misc
openstack-config --set /etc/nova/nova.conf oslo_concurrency lock_path "/var/lib/nova/tmp"
egrep -c '(vmx|svm)' /proc/cpuinfo || openstack-config --set /etc/nova/nova.conf libvirt virt_type "qemu"

# Start the Compute services and configure them to start when the system boots:
systemctl enable libvirtd.service openstack-nova-compute.service
systemctl start libvirtd.service openstack-nova-compute.service


### For Neutron

# rabbit
openstack-config --set /etc/neutron/neutron.conf DEFAULT rpc_backend "rabbit"
openstack-config --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_host "controller"
openstack-config --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_userid "openstack"
openstack-config --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_password "$RABBIT_PASS"

# keystone
openstack-config --set /etc/neutron/neutron.conf DEFAULT auth_strategy "keystone"
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken auth_uri "http://controller:5000"
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken auth_url "http://controller:35357"
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken memcached_servers "controller:11211"
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken auth_type "password"
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken project_domain_name "default"
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken user_domain_name "default"
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken project_name "service"
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken username "neutron"
openstack-config --set /etc/neutron/neutron.conf keystone_authtoken password "$NEUTRON_PASS"

# misc
openstack-config --set /etc/neutron/neutron.conf oslo_concurrency lock_path "/var/lib/neutron/tmp"

# nova
openstack-config --set /etc/nova/nova.conf neutron url "http://controller:9696"
openstack-config --set /etc/nova/nova.conf neutron auth_url "http://controller:35357"
openstack-config --set /etc/nova/nova.conf neutron auth_type "password"
openstack-config --set /etc/nova/nova.conf neutron project_domain_name "default"
openstack-config --set /etc/nova/nova.conf neutron user_domain_name "default"
openstack-config --set /etc/nova/nova.conf neutron region_name "RegionOne"
openstack-config --set /etc/nova/nova.conf neutron project_name "service"
openstack-config --set /etc/nova/nova.conf neutron username "neutron"
openstack-config --set /etc/nova/nova.conf neutron password "$NEUTRON_PASS"

# Restart the Compute service:
systemctl restart openstack-nova-compute.service

# Start the Linux bridge agent and configure it to start when the system boots:
systemctl enable neutron-linuxbridge-agent.service
systemctl start neutron-linuxbridge-agent.service
