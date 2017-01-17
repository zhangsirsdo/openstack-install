#!/bin/bash
# register service to etcd

ETCD_HOST=${ETCD_HOST:=127.0.0.1}
ETCD_PORT=${ETCD_PORT:=2379}
DB_HOST=${DB_HOST:=$ETCD_HOST}
DB_PORT=${DB_PORT:=3306}
DB_USER=${DB_USER:=root}
DB_PASS=${DB_PASS:=root}
KEYSTONE_DB_PASS=${KEYSTONE_DB_PASS:=$DB_PASS}
GLANCE_DB_PASS=${GLANCE_DB_PASS:=$DB_PASS}
NOVA_DB_PASS=${NOVA_DB_PASS:=$DB_PASS}
NEUTRON_DB_PASS=${NEUTRON_DB_PASS:=$DB_PASS}
CINDER_DB_PASS=${CINDER_DB_PASS:=$DB_PASS}

# save params of mariadb to etcd
curl -L -XPUT http://$ETCD_HOST:$ETCD_PORT/v2/keys/endpoints/mariadb/host -d value="$DB_HOST"
curl -L -XPUT http://$ETCD_HOST:$ETCD_PORT/v2/keys/endpoints/mariadb/port -d value="$DB_PORT"
curl -L -XPUT http://$ETCD_HOST:$ETCD_PORT/v2/keys/endpoints/mariadb/user -d value="$DB_USER"
curl -L -XPUT http://$ETCD_HOST:$ETCD_PORT/v2/keys/endpoints/mariadb/pass -d value="$DB_PASS"
curl -L -XPUT http://$ETCD_HOST:$ETCD_PORT/v2/keys/endpoints/mariadb/keystone_db_pass -d value="$KEYSTONE_DB_PASS"
curl -L -XPUT http://$ETCD_HOST:$ETCD_PORT/v2/keys/endpoints/mariadb/glance_db_pass -d value="$GLANCE_DB_PASS"
curl -L -XPUT http://$ETCD_HOST:$ETCD_PORT/v2/keys/endpoints/mariadb/nova_db_pass -d value="$NOVA_DB_PASS"
curl -L -XPUT http://$ETCD_HOST:$ETCD_PORT/v2/keys/endpoints/mariadb/neutron_db_pass -d value="$NEUTRON_DB_PASS"
curl -L -XPUT http://$ETCD_HOST:$ETCD_PORT/v2/keys/endpoints/mariadb/cinder_db_pass -d value="$CINDER_DB_PASS"
