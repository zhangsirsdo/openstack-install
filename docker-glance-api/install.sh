#!/bin/bash

ADVERTISEMENT_URL=${ADVERTISEMENT_URL:-127.0.0.1:2379}
ADVERTISEMENT_HOST=`echo $ADVERTISEMENT_URL|awk -F ':' '{print $1}'`
GLANCE_PASS=${GLANCE_PASS:-root}
GLANCE_DB_PASS=${GLANCE_DB_PASS:-root}
DB_HOST=${DB_HOST:-$ADVERTISEMENT_HOST}
KEYSTONE_INTERNAL_PORT=${KEYSTONE_INTERNAL_PORT:-5000}
KEYSTONE_ADMIN_PORT=${KEYSTONE_ADMIN_PORT:-35357}
ADMIN_PASS=${ADMIN_PASS:-root}

export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=$ADMIN_PASS
export OS_AUTH_URL=http://$ADVERTISEMENT_HOST:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
export OS_AUTH_TYPE=password
openstack user create --domain default --password $GLANCE_PASS glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://$ADVERTISEMENT_HOST:9292
openstack endpoint create --region RegionOne image internal http://$ADVERTISEMENT_HOST:9292
openstack endpoint create --region RegionOne image admin http://$ADVERTISEMENT_HOST:9292

openstack-config --set /etc/glance/glance-api.conf database connection "mysql+pymysql://glance:$GLANCE_DB_PASS@$DB_HOST/glance"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_uri "http://$ADVERTISEMENT_HOST:$KEYSTONE_INTERNAL_PORT"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_url "http://$ADVERTISEMENT_HOST:$KEYSTONE_ADMIN_PORT"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken memcached_servers "$ADVERTISEMENT_HOST:11211"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken auth_type "password"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken project_domain_name "default"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken user_domain_name "default"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken project_name "service"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken username "glance"
openstack-config --set /etc/glance/glance-api.conf keystone_authtoken password "$GLANCE_PASS"
openstack-config --set /etc/glance/glance-api.conf paste_deploy flavor "keystone"
openstack-config --set /etc/glance/glance-api.conf paste_deploy config_file "/usr/share/glance/glance-api-dist-paste.ini"
openstack-config --set /etc/glance/glance-api.conf glance_store stores "file,http"
openstack-config --set /etc/glance/glance-api.conf glance_store default_store "file"
openstack-config --set /etc/glance/glance-api.conf glance_store filesystem_store_datadir "/var/lib/glance/images/"

res=`mysql -h$DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "select count(*) from information_schema.tables where table_schema='glance';"`
count=`echo $res|awk -F ' ' '{print $2}'`
if [ "$count" -eq 0 ];then
  su -s /bin/sh -c "glance-manage db_sync" glance
fi

/usr/bin/python2.7 /usr/bin/glance-api --config-file /etc/glance/glance-api.conf
