#!/bin/bash

ADMIN_TOKEN=${ADMIN_TOKEN:=`curl -L -XGET \
  http://$ADVERTISEMENT_URL:$ETCD_PORT/v2/keys/endpoints/keystone/admin_token|jq -r '.node.value'`}
ADMIN_PASS=${ADMIN_PASS:=`curl -L -XGET \
  http://$ADVERTISEMENT_URL:$ETCD_PORT/v2/keys/endpoints/keystone/admin_pass|jq -r '.node.value'`}
DEMO_PASS=${DEMO_PASS:=`curl -L -XGET \
  http://$ADVERTISEMENT_URL:$ETCD_PORT/v2/keys/endpoints/keystone/demo_pass|jq -r '.node.value'`}
OS_IDENTITY_API_VERSION=${OS_IDENTITY_API_VERSION:=`curl -L -XGET \
  http://$ADVERTISEMENT_URL:$ETCD_PORT/v2/keys/endpoints/keystone/os_identity_api_version|jq -r '.node.value'`}

OS_TOKEN=$ADMIN_TOKEN
OS_URL=http://$ADVERTISEMENT_URL:35357/v3

#keystone:
# Create the service entity for the Identity service
openstack service create --name keystone --description "OpenStack Identity" identity
# OpenStack uses three API endpoint variants for each service: admin, internal, and public. 
#
# The admin API endpoint allows modifying users and tenants by default, while the public 
# and internal APIs do not allow these operations. 
#
# In a production environment, the variants might reside on separate networks that service 
# different types of users for security reasons. 
openstack endpoint create --region RegionOne identity public http://$ADVERTISEMENT_URL:5000/v3
openstack endpoint create --region RegionOne identity internal http://$ADVERTISEMENT_URL:5000/v3
openstack endpoint create --region RegionOne identity admin http://$ADVERTISEMENT_URL:35357/v3
# Create the default domain
openstack domain create --description "Default Domain" default

# Create an administrative project, user, and role for administrative operations
openstack project create --domain default --description "Admin Project" admin
openstack user create --domain default --password $ADMIN_PASS admin
openstack role create admin
openstack role add --project admin --user admin admin

# Create the service project
openstack project create --domain default --description "Service Project" service

# Regular (non-admin) tasks should use an unprivileged project and user. 
# As an example, Create the demo project:
openstack project create --domain default --description "Demo Project" demo
# Create the demo user
openstack user create --domain default --password $DEMO_PASS demo
# Create the user role
openstack role create user
# Add the user role to the demo project and user
openstack role add --project demo --user demo user


