#!/bin/bash

ADVERTISEMENT_URL=`cat ../global.conf |grep ADVERTISEMENT_URL|awk -F '=' '{print $2}'`
ADVERTISEMENT_URL=${ADVERTISEMENT_URL:=127.0.0.1:2379}

# install keystone container
KEYSTONE_HOST=${KEYSTONE_HOST:=`echo $ADVERTISEMENT_URL|awk -F ':' '{print $1}'`}
KEYSTONE_ADMIN_PORT=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/keystone/admin_port|jq -r '.node.value'`
KEYSTONE_INTERNAL_PORT=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/keystone/internal_port|jq -r '.node.value'`
ADMIN_TOKEN=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/keystone/admin_token|jq -r '.node.value'`
KEYSTONE_DB_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/keystone_db_pass|jq -r '.node.value'`
DB_HOST=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/host|jq -r '.node.value'`
DB_PORT=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/port|jq -r '.node.value'`
DB_USER=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/user|jq -r '.node.value'`
DB_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/mariadb/pass|jq -r '.node.value'`
KEYSTONE_ADMIN_PORT=${KEYSTONE_ADMIN_PORT:=35357}
KEYSTONE_INTERNAL_PORT=${KEYSTONE_INTERNAL_PORT:=5000}
ADMIN_TOKEN=${ADMIN_TOKEN:=016f77abde58da9c724b}
cp openstack_keystone_compose_template.yml openstack_keystone_compose.yml
sed -i "s#KEYSTONE_ADMIN_PORT#$KEYSTONE_ADMIN_PORT#g" openstack_keystone_compose.yml
sed -i "s#KEYSTONE_INTERNAL_PORT#$KEYSTONE_INTERNAL_PORT#g" openstack_keystone_compose.yml
sed -i "s#ADMIN_TOKEN_VAR#$ADMIN_TOKEN#g" openstack_keystone_compose.yml
sed -i "s#KEYSTONE_DB_PASS_VAR#$KEYSTONE_DB_PASS#g" openstack_keystone_compose.yml
sed -i "s#DB_HOST_VAR#$DB_HOST#g" openstack_keystone_compose.yml
sed -i "s#DB_PORT_VAR#$DB_PORT#g" openstack_keystone_compose.yml
sed -i "s#DB_USER_VAR#$DB_USER#g" openstack_keystone_compose.yml
sed -i "s#DB_PASS_VAR#$DB_PASS#g" openstack_keystone_compose.yml
docker-compose -f ./openstack_keystone_compose.yml up -d
rm -f openstack_keystone_compose.yml
# save configuration of keystone to etcd
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/keystone/host -d value="$KEYSTONE_HOST"


# install keystone_setup container
ADMIN_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/keystone/admin_pass|jq -r '.node.value'`
DEMO_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/keystone/demo_pass|jq -r '.node.value'`
ADMIN_PASS=${ADMIN_PASS:=root}
DEMO_PASS=${DEMO_PASS:=root}
penstack_keystone_setup_compose_template.yml openstack_keystone_setup_compose.yml
sed -i "s#ADMIN_TOKEN_VAR#$ADMIN_TOKEN#g" openstack_keystone_setup_compose.yml
sed -i "s#ADMIN_PASS_VAR#$ADMIN_PASS#g" openstack_keystone_setup_compose.yml
sed -i "s#DEMO_PASS_VAR#$DEMO_PASS#g" openstack_keystone_setup_compose.yml
docker-compose -f ./openstack_keystone_setup_compose.yml up -d
rm -f openstack_keystone_setup_compose.yml
# save configuration of keystone_setup to etcd
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/keystone_setup/admin_pass -d value="$ADMIN_PASS"
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/keystone_setup/demo_pass -d value="$DEMO_PASS"



























