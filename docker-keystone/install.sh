#!/bin/bash

ADMIN_TOKEN=${ADMIN_TOKEN:=016f77abde58da9c724b}
KEYSTONE_DB_PASS=${KEYSTONE_DB_PASS:=root}
DB_HOST=${DB_HOST:=localhost}
DB_PORT=${DB_PORT:=3306}
DB_USER=${DB_USER:=root}
DB_PASS=${DB_PASS:=root}

openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token $ADMIN_TOKEN
openstack-config --set /etc/keystone/keystone.conf DEFAULT debug true
openstack-config --set /etc/keystone/keystone.conf DEFAULT log_date_format "%Y-%m-%d %H:%M:%S"
openstack-config --set /etc/keystone/keystone.conf token provider fernet
openstack-config --set /etc/keystone/keystone.conf database connection "mysql+pymysql://keystone:$KEYSTONE_DB_PASS@$DB_HOST/keystone"

res=`mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "select COUNT(*) from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='keystone' and TABLE_NAME='endpointttt';"`
count=`echo $res|awk -F ' ' '{print $2}'`

if [ "$count" -eq 0 ];then
  su -s /bin/sh -c "keystone-manage db_sync" keystone
  keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
fi

keystone-all --config-file /etc/keystone/keystone.conf
