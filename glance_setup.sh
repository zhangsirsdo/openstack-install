#!/bin/bash

source $PWD/env.sh
source $PWD/admin-openrc.sh

# Create the glance user
openstack user create --domain default --password $GLANCE_PASS glance

# Add the admin role to the glance user and service project
openstack role add --project service --user glance admin

# Create the glance service entity
openstack service create --name glance --description "OpenStack Image" image

# Create the Image service API endpoints
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292

# config
openstack-config --set /etc/glance/glance-api.conf database connection "mysql+pymysql://glance:$GLANCE_DBPASS@localhost/glance"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_uri "http://controller:5000"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_url "http://controller:35357"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken memcached_servers "controller:11211"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_type "password"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken project_domain_name "default"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken user_domain_name "default"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken project_name "service"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken username "glance"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken password "$GLANCE_PASS"
openstack-config --set /etc/glance/glance-api.conf paste_deploy flavor "keystone"
openstack-config --set /etc/glance/glance-api.conf glance_store stores "file,http"
openstack-config --set /etc/glance/glance-api.conf glance_store default_store "file"
openstack-config --set /etc/glance/glance-api.conf glance_store filesystem_store_datadir "/var/lib/glance/images/"


openstack-config --set /etc/glance/glance-registry.conf database connection "mysql+pymysql://glance:$GLANCE_DBPASS@localhost/glance"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_uri "http://controller:5000"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_url "http://controller:35357"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken memcached_servers "controller:11211"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_type "password"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken project_domain_name "default"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken user_domain_name "default"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken project_name "service"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken username "glance"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken password "$GLANCE_PASS"
openstack-config --set /etc/glance/glance-registry.conf paste_deploy flavor "keystone"

# Populate the Image service database
su -s /bin/sh -c "glance-manage db_sync" glance

#Start the Image services and configure them to start when the system boots
systemctl enable openstack-glance-api.service \
  openstack-glance-registry.service
systemctl start openstack-glance-api.service \
  openstack-glance-registry.service
