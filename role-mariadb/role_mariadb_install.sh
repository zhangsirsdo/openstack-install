#!/bin/bash
# install mariadb and mariadb_setup container

ADVERTISEMENT_URL=`cat ../global.conf |grep ADVERTISEMENT_URL|awk -F '=' '{print $2}'`
ADVERTISEMENT_URL=${ADVERTISEMENT_URL:=127.0.0.1:2379}
DB_HOST=${DB_HOST:=`echo $ADVERTISEMENT_URL|awk -F ':' '{print $1}'`}

DB_PORT=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/port|jq -r '.node.value'`
DB_USER=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/user|jq -r '.node.value'`
DB_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/pass|jq -r '.node.value'`
KEYSTONE_DB_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/keystone_db_pass|jq -r '.node.value'`
GLANCE_DB_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/glance_db_pass|jq -r '.node.value'`
NOVA_DB_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/nova_db_pass|jq -r '.node.value'`
NEUTRON_DB_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/neutron|jq -r '.node.value'`
CINDER_DB_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/cinder_db_pass|jq -r '.node.value'`
DB_PORT=${DB_PORT:=3306}
DB_USER=${DB_USER:=root}
DB_PASS=${DB_PASS:=root}
KEYSTONE_DB_PASS=${KEYSTONE_DB_PASS:=$DB_PASS}
GLANCE_DB_PASS=${GLANCE_DB_PASS:=$DB_PASS}
NOVA_DB_PASS=${NOVA_DB_PASS:=$DB_PASS}
NEUTRON_DB_PASS=${NEUTRON_DB_PASS:=$DB_PASS}
CINDER_DB_PASS=${CINDER_DB_PASS:=$DB_PASS}

compose_path="/etc/docker_compose/"
if [ ! -x "$compose_path" ]; then
  mkdir -p $compose_path
fi
# generate compose file of mariadb
cp openstack_mariadb_compose_template.yml $compose_path"openstack_mariadb_compose.yml"
sed -i "s#DB_PASS#$DB_PASS#g" $compose_path"openstack_mariadb_compose.yml"
sed -i "s#DB_PORT#$DB_PORT#g" $compose_path"openstack_mariadb_compose.yml"
# start mariadb container
docker-compose -f $compose_path"openstack_mariadb_compose.yml" up -d 
# save params of mariadb to etcd
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/host -d value="$DB_HOST"

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
cp openstack_mariadb_setup_compose_template.yml $compose_path"openstack_mariadb_setup_compose.yml"
sed -i "s#DB_HOST_VAR#$DB_HOST#g" $compose_path"openstack_mariadb_setup_compose.yml"
sed -i "s#DB_PORT_VAR#$DB_PORT#g" $compose_path"openstack_mariadb_setup_compose.yml"
sed -i "s#DB_USER_VAR#$DB_USER#g" $compose_path"openstack_mariadb_setup_compose.yml"
sed -i "s#DB_PASS_VAR#$DB_PASS_VAR#g" $compose_path"openstack_mariadb_setup_compose.yml"
sed -i "s#KEYSTONE_DB_PASS_VAR#$KEYSTONE_DB_PASS#g" $compose_path"openstack_mariadb_setup_compose.yml"
sed -i "s#GLANCE_DB_PASS_VAR#$GLANCE_DB_PASS#g" $compose_path"openstack_mariadb_setup_compose.yml"
sed -i "s#NOVA_DB_PASS_VAR#$NOVA_DB_PASS#g" $compose_path"openstack_mariadb_setup_compose.yml"
sed -i "s#NEUTRON_DB_PASS_VAR#$NEUTRON_DB_PASS#g" $compose_path"openstack_mariadb_setup_compose.yml"
sed -i "s#CINDER_DB_PASS_VAR#$CINDER_DB_PASS#g" $compose_path"openstack_mariadb_setup_compose.yml"
# start mariadb_setup container
docker-compose -f $compose_path"openstack_mariadb_setup_compose.yml" up -d
