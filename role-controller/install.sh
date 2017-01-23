#!/bin/bash

ADVERTISEMENT_URL=`cat ../global.conf |grep ADVERTISEMENT_URL|awk -F '=' '{print $2}'`
ADVERTISEMENT_URL=${ADVERTISEMENT_URL:=127.0.0.1:2379}

compose_path="/etc/docker_compose/"
if [ ! -x "$compose_path" ]; then
  mkdir -p $compose_path
fi

#install rabbitmq container
RABBITMQ_PORT1=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/rabbitmq/rabbitmq_port1|jq -r '.node.value'`
RABBITMQ_PORT2=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/rabbitmq/rabbitmq_port2|jq -r '.node.value'`
RABBITMQ_PORT3=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/rabbitmq/rabbitmq_port3|jq -r '.node.value'`
RABBITMQ_PORT4=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/rabbitmq/rabbitmq_port4|jq -r '.node.value'`
RABBITMQ_USER=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/rabbitmq/rabbitmq_user|jq -r '.node.value'`
RABBITMQ_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/rabbitmq/rabbitmq_pass|jq -r '.node.value'`
cp openstack_rabbitmq_compose_template.yml $compose_path"openstack_rabbitmq_compose.yml"
sed -i "s#RABBITMQ_PORT1#$RABBITMQ_PORT1#g" $compose_path"openstack_rabbitmq_compose.yml"
sed -i "s#RABBITMQ_PORT2#$RABBITMQ_PORT2#g" $compose_path"openstack_rabbitmq_compose.yml"
sed -i "s#RABBITMQ_PORT3#$RABBITMQ_PORT3#g" $compose_path"openstack_rabbitmq_compose.yml"
sed -i "s#RABBITMQ_PORT4#$RABBITMQ_PORT4#g" $compose_path"openstack_rabbitmq_compose.yml"
sed -i "s#RABBITMQ_USER#$RABBITMQ_USER#g" $compose_path"openstack_rabbitmq_compose.yml"
sed -i "s#RABBITMQ_PASS#$RABBITMQ_PASS#g" $compose_path"openstack_rabbitmq_compose.yml"
docker-compose -f $compose_path"openstack_rabbitmq_compose.yml" up -d
rabbitmq_container_id=`docker ps -a|grep rabbitmq|awk '{print $1}'`
while [ $rabbitmq_container_id == "" ]
do
  sleep 1
  rabbitmq_container_id=`docker ps -a|grep rabbitmq|awk '{print $1}'`
done
docker exec -it $rabbitmq_container_id rabbitmqctl set_permissions $RABBITMQ_USER ".*" ".*" ".*"
# save configuration of rabbit to etcd
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/rabbitmq/host -d value="$KEYSTONE_HOST"


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

cp openstack_keystone_compose_template.yml $compose_path"openstack_keystone_compose.yml"
sed -i "s#KEYSTONE_ADMIN_PORT#$KEYSTONE_ADMIN_PORT#g" $compose_path"openstack_keystone_compose.yml"
sed -i "s#KEYSTONE_INTERNAL_PORT#$KEYSTONE_INTERNAL_PORT#g" $compose_path"openstack_keystone_compose.yml"
sed -i "s#ADMIN_TOKEN_VAR#$ADMIN_TOKEN#g" $compose_path"openstack_keystone_compose.yml"
sed -i "s#KEYSTONE_DB_PASS_VAR#$KEYSTONE_DB_PASS#g" $compose_path"openstack_keystone_compose.yml"
sed -i "s#MARIADB_HOST_VAR#$DB_HOST#g" $compose_path"openstack_keystone_compose.yml"
sed -i "s#MARIADB_PORT_VAR#$DB_PORT#g" $compose_path"openstack_keystone_compose.yml"
sed -i "s#MARIADB_USER_VAR#$DB_USER#g" $compose_path"openstack_keystone_compose.yml"
sed -i "s#MARIADB_PASS_VAR#$DB_PASS#g" $compose_path"openstack_keystone_compose.yml"
docker-compose -f $compose_path"openstack_keystone_compose.yml" up -d
# save configuration of keystone to etcd
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/keystone/host -d value="$KEYSTONE_HOST"


# install keystone_setup container
ADMIN_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/keystone/admin_pass|jq -r '.node.value'`
DEMO_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/keystone/demo_pass|jq -r '.node.value'`
ADMIN_PASS=${ADMIN_PASS:=root}
DEMO_PASS=${DEMO_PASS:=root}
OS_IDENTITY_API_VERSION=${OS_IDENTITY_API_VERSION:=3}
cp openstack_keystone_setup_compose_template.yml $compose_path"openstack_keystone_setup_compose.yml"
sed -i "s#ADMIN_TOKEN_VAR#$ADMIN_TOKEN#g" $compose_path"openstack_keystone_setup_compose.yml"
sed -i "s#ADMIN_PASS_VAR#$ADMIN_PASS#g" $compose_path"openstack_keystone_setup_compose.yml"
sed -i "s#DEMO_PASS_VAR#$DEMO_PASS#g" $compose_path"openstack_keystone_setup_compose.yml"
sed -i "s#OS_IDENTITY_API_VERSION_VAR#$OS_IDENTITY_API_VERSION#g" $compose_path"openstack_keystone_setup_compose.yml"
sed -i "s#ADVERTISEMENT_URL_VAR#$ADVERTISEMENT_URL#g" $compose_path"openstack_keystone_setup_compose.yml"
docker-compose -f $compose_path"openstack_keystone_setup_compose.yml" up -d
# save configuration of keystone_setup to etcd
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/keystone_setup/admin_pass -d value="$ADMIN_PASS"
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/keystone_setup/demo_pass -d value="$DEMO_PASS"

# install glance_api container
GLANCE_HOST=${GLANCE_HOST:=`echo $ADVERTISEMENT_URL|awk -F ':' '{print $1}'`}
GLANCE_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/glance/pass|jq -r '.node.value'`
GLANCE_DB_PASS=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/glance/pass|jq -r '.node.value'`
GLANCE_PASS=${GLANCE_PASS:-root}
GLANCE_DB_PASS=${GLANCE_DB_PASS:-root}
GLANCE_API_PORT=${GLANCE_PORT:-9292}
GLANCE_REGISTRY_PORT=${GLANCE_REGISTRY_PORT:-9191}

cp openstack_glance_api_compose_template.yml $compose_path"openstack_glance_api_compose_template.yml"
sed -i "s#GLANCE_PASS_VAR#$GLANCE_PASS#g" $compose_path"openstack_glance_api_compose_template.yml"
sed -i "s#GLANCE_DB_PASS_VAR#$GLANCE_DB_PASS#g" $compose_path"openstack_glance_api_compose_template.yml"
sed -i "s#KEYSTONE_INTERNAL_PORT_VAR#$KEYSTONE_INTERNAL_PORT#g" $compose_path"openstack_glance_api_compose_template.yml"
sed -i "s#KEYSTONE_ADMIN_PORT_VAR#$KEYSTONE_ADMIN_PORT#g" $compose_path"openstack_glance_api_compose_template.yml"
sed -i "s#ADMIN_PASS_VAR#$ADMIN_PASS#g" $compose_path"openstack_glance_api_compose_template.yml"
sed -i "s#ADVERTISEMENT_URL_VAR#$ADVERTISEMENT_URL#g" $compose_path"openstack_glance_api_compose_template.yml"
sed -i "s#GLANCE_API_PORT_VAR#$GLANCE_API_PORT#g" $compose_path"openstack_glance_api_compose_template.yml"
docker-compose -f $compose_path"openstack_glance_api_compose_template.yml" up -d
# save configuration of keystone_setup to etcd
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/glance/host -d value="$GLANCE_HOST"
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/glance/api_port -d value="$GLANCE_API_PORT"

# install glance-registry container
cp openstack_glance_registry_compose_template.yml $compose_path"openstack_glance_registry_compose_template.yml"
sed -i "s#GLANCE_PASS_VAR#$GLANCE_PASS#g" $compose_path"openstack_glance_registry_compose_template.yml"
sed -i "s#GLANCE_DB_PASS_VAR#$GLANCE_DB_PASS#g" $compose_path"openstack_glance_registry_compose_template.yml"
sed -i "s#KEYSTONE_INTERNAL_PORT_VAR#$KEYSTONE_INTERNAL_PORT#g" $compose_path"openstack_glance_registry_compose_template.yml"
sed -i "s#KEYSTONE_ADMIN_PORT_VAR#$KEYSTONE_ADMIN_PORT#g" $compose_path"openstack_glance_registry_compose_template.yml"
sed -i "s#ADVERTISEMENT_URL_VAR#$ADVERTISEMENT_URL#g" $compose_path"openstack_glance_registry_compose_template.yml"
sed -i "s#GLANCE_REGISTRY_PORT_VAR#$GLANCE_REGISTRY_PORT#g" $compose_path"openstack_glance_registry_compose_template.yml"
docker-compose -f $compose_path"openstack_glance_registry_compose_template.yml" up -d
# save configuration of keystone_setup to etcd
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/glance/registry_port -d value="$GLANCE_REGISTRY_PORT"







