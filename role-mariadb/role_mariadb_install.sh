#!/bin/bash
# install mariadb and mariadb_setup container

ADVERTISEMENT_URL=`cat ../global.conf |grep ADVERTISEMENT_URL|awk -F '=' '{print $2}'`
ADVERTISEMENT_URL=${ADVERTISEMENT_URL:=127.0.0.1:2379}
export ADVERTISEMENT_URL
export DB_HOST=${DB_HOST:=`echo $ADVERTISEMENT_URL|awk -F ':' '{print $1}'`}
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
cp openstack_mariadb_compose_template.yml openstack_mariadb_compose.yml
sed -i "s#DB_PASS#$DB_PASS#g" openstack_mariadb_compose.yml
sed -i "s#MARIADB_PORT#$DB_PORT#g" openstack_mariadb_compose.yml
# start mariadb container
docker-compose -f ./openstack_mariadb_compose.yml up -d 
rm -f openstack_mariadb_compose.yml

# save params of mariadb to etcd
sh ./role_mariadb_register.sh

# detect whether the params of mariadb exist or not
mariadb_status=`curl -L -XGET http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/host`
res=$(echo $mariadb_status | grep "errorCode")
while [ $res != "" ]
do
  sleep 1
  mariadb_status=`curl -L -XGET http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/host`
  res=$(echo $mariadb_status | grep "errorCode")
done

# generate compose file of mariadb_setup
cp openstack_mariadb_setup_compose_template.yml openstack_mariadb_setup_compose.yml
sed -i "s#DB_HOST_VAR#$DB_HOST#g" openstack_mariadb_setup_compose.yml
sed -i "s#DB_PORT_VAR#$DB_PORT#g" openstack_mariadb_setup_compose.yml
sed -i "s#DB_USER_VAR#$DB_USER#g" openstack_mariadb_setup_compose.yml
sed -i "s#DB_PASS_VAR#$DB_PASS_VAR#g" openstack_mariadb_setup_compose.yml
sed -i "s#KEYSTONE_DB_PASS_VAR#$KEYSTONE_DB_PASS#g" openstack_mariadb_setup_compose.yml
sed -i "s#GLANCE_DB_PASS_VAR#$GLANCE_DB_PASS#g" openstack_mariadb_setup_compose.yml
sed -i "s#NOVA_DB_PASS_VAR#$NOVA_DB_PASS#g" openstack_mariadb_setup_compose.yml
sed -i "s#NEUTRON_DB_PASS_VAR#$NEUTRON_DB_PASS#g" openstack_mariadb_setup_compose.yml
sed -i "s#CINDER_DB_PASS_VAR#$CINDER_DB_PASS#g" openstack_mariadb_setup_compose.yml
# start mariadb_setup container
docker-compose -f ./openstack_mariadb_setup_compose.yml up -d
rm -f openstack_mariadb_setup_compose.yml
