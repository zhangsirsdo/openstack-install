#!/bin/bash

yum install -y python-openstackclient openstack-utils
yum install -y openstack-keystone httpd mod_wsgi
yum install -y openstack-glance
yum install -y openstack-nova-api openstack-nova-conductor \
            openstack-nova-console openstack-nova-novncproxy \
            openstack-nova-scheduler
yum install -y openstack-neutron openstack-neutron-ml2 \
          openstack-neutron-linuxbridge ebtables
