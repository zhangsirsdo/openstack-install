#!/bin/bash

ADVERTISEMENT_URL=${ADVERTISEMENT_URL:-127.0.0.1:2379}
ADVERTISEMENT_HOST=`echo $ADVERTISEMENT_URL|awk -F ':' '{print $1}'`
GLANCE_PASS=${GLANCE_PASS:-root}
GLANCE_DB_PASS=${GLANCE_DB_PASS:-root}
DB_HOST=${DB_HOST:-$ADVERTISEMENT_HOST}
KEYSTONE_INTERNAL_PORT=${KEYSTONE_INTERNAL_PORT:-5000}
KEYSTONE_ADMIN_PORT=${KEYSTONE_ADMIN_PORT:-35357}

openstack-config --set /etc/glance/glance-registry.conf database connection "mysql+pymysql://glance:$GLANCE_DB_PASS@$DB_HOST/glance"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_uri "http://$ADVERTISEMENT_HOST:$KEYSTONE_INTERNAL_PORT"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_url "http://$ADVERTISEMENT_HOST:$KEYSTONE_ADMIN_PORT"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken memcached_servers "$ADVERTISEMENT_HOST:11211"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken auth_type "password"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken project_domain_name "default"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken user_domain_name "default"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken project_name "service"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken username "glance"
openstack-config --set /etc/glance/glance-registry.conf keystone_authtoken password "$GLANCE_PASS"
openstack-config --set /etc/glance/glance-registry.conf paste_deploy flavor "keystone"
openstack-config --set /etc/glance/glance-registry.conf paste_deploy config_file "/usr/share/glance/glance-registry-dist-paste.ini"

/usr/bin/python2.7 /usr/bin/glance-registry --config-file /etc/glance/glance-registry.conf
