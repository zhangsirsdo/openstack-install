#!/bin/bash

ADMIN_TOKEN=${ADMIN_TOKEN:=`curl -L -XGET \
  http://$ETCD_ADVERTISEMENT_URL:$ETCD_PORT/v2/keys/endpoints/keystone/admin_token|jq -r '.node.value'`}
KEYSTONE_DB_PASS=${KEYSTONE_DB_PASS:=`curl -L -XGET \
  http://$ETCD_ADVERTISEMENT_URL:$ETCD_PORT/v2/keys/endpoints/mariadb/keystone_db_pass|jq -r '.node.value'`}
DB_HOST=${DB_HOST:=`curl -L -XGET \
  http://$ETCD_ADVERTISEMENT_URL:$ETCD_PORT/v2/keys/endpoints/mariadb/host|jq -r '.node.value'`}
DB_PORT=${DB_PORT:=`curl -L -XGET \
  http://$ETCD_ADVERTISEMENT_URL:$ETCD_PORT/v2/keys/endpoints/mariadb/port|jq -r '.node.value'`}
DB_USER=${DB_USER:=`curl -L -XGET \
  http://$ETCD_ADVERTISEMENT_URL:$ETCD_PORT/v2/keys/endpoints/mariadb/user|jq -r '.node.value'`}
DB_PASS=${DB_PASS:=`curl -L -XGET \
  http://$ETCD_ADVERTISEMENT_URL:$ETCD_PORT/v2/keys/endpoints/mariadb/pass|jq -r '.node.value'`}

openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token $ADMIN_TOKEN
openstack-config --set /etc/keystone/keystone.conf DEFAULT debug true
openstack-config --set /etc/keystone/keystone.conf DEFAULT log_date_format "%Y-%m-%d %H:%M:%S"
openstack-config --set /etc/keystone/keystone.conf token provider fernet
openstack-config --set /etc/keystone/keystone.conf database connection "mysql+pymysql://keystone:$KEYSTONE_DB_PASS@$DB_HOST/keystone"

res=`mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "select COUNT(*) from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='keystone' and TABLE_NAME='endpoint';"`
count=`echo $res|awk -F ' ' '{print $2}'`

if [ "$count" -eq 0 ];then
  su -s /bin/sh -c "keystone-manage db_sync" keystone
  keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
fi

keystone-all --config-file /etc/keystone/keystone.conf
