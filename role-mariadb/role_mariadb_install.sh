#!/bin/bash
# install mariadb and mariadb_setup container

export ETCD_HOST=${ETCD_HOST:=127.0.0.1}
export ETCD_PORT=${ETCD_PORT:=2379}
export DB_HOST=${DB_HOST:=$ETCD_HOST}
export DB_PORT=${DB_PORT:=3306}
export DB_USER=${DB_USER:=root}
export DB_PASS=${DB_PASS:=root}
export KEYSTONE_DB_PASS=${KEYSTONE_DB_PASS:=$DB_PASS}
export GLANCE_DB_PASS=${GLANCE_DB_PASS:=$DB_PASS}
export NOVA_DB_PASS=${NOVA_DB_PASS:=$DB_PASS}
export NEUTRON_DB_PASS=${NEUTRON_DB_PASS:=$DB_PASS}
export CINDER_DB_PASS=${CINDER_DB_PASS:=$DB_PASS}
export DB_CONTAINER_NAME=${DB_CONTAINER_NAME:=mariadb_1}

# generate compose file of mariadb
cat <<EOF >./openstack_mariadb_compose.yml
version: '2'
services:
  mariadb:
    image: 'mariadb:10.1.20'
    network_mode: "host"
    environment:
        - MYSQL_ROOT_PASSWORD=$DB_PASS
EOF

# start mariadb container
docker-compose -f ./openstack_mariadb_compose.yml up -d 

# save params of mariadb to etcd
sh ./role_mariadb_register.sh

# detect whether the params of mariadb exist or not
mariadb_status=`curl -L -XGET http://$ETCD_HOST:$ETCD_PORT/v2/keys/endpoints/mariadb/host`
res=$(echo $mariadb_status | grep "errorCode")
while [ $res != "" ]
do
  sleep 1
  mariadb_status=`curl -L -XGET http://$ETCD_HOST:$ETCD_PORT/v2/keys/endpoints/mariadb/host`
  res=$(echo $mariadb_status | grep "errorCode")
done

# generate compose file of mariadb_setup
cat <<EOF >./openstack_mariadb_setup_compose.yml
version: '2'
services:
  mariadb_setup:
    image: 'mariadb_setup:1'
    network_mode: "host"
    environment:
        - DB_HOST=$DB_HOST
        - DB_PORT=$DB_PORT
        - DB_USER=$DB_USER
        - DB_PASS=$DB_PASS
        - KEYSTONE_DB_PASS=$KEYSTONE_DB_PASS
        - GLANCE_DB_PASS=$GLANCE_DB_PASS
        - NOVA_DB_PASS=$NOVA_DB_PASS
        - NEUTRON_DB_PASS=$NEUTRON_DB_PASS
        - CINDER_DB_PASS=$CINDER_DB_PASS
EOF

# start mariadb_setup container
docker-compose -f ./openstack_mariadb_setup_compose.yml up -d
