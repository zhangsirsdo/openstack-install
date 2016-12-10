#!/bin/bash

yum install -y python-openstackclient openstack-utils
yum install -y openstack-keystone httpd mod_wsgi
yum install -y openstack-glance
yum install openstack-nova-api openstack-nova-conductor \
            openstack-nova-console openstack-nova-novncproxy \
            openstack-nova-scheduler
