source /home/config.sh
source $PWD/env.sh
source $PWD/os-openrc.sh

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
openstack endpoint create --region RegionOne identity public http://$CONTROLLER:5000/v3
openstack endpoint create --region RegionOne identity internal http://$CONTROLLER:5000/v3
openstack endpoint create --region RegionOne identity admin http://$CONTROLLER:35357/v3

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


cat <<EOF >$PWD/admin-openrc.sh
#!/bin/bash
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=$ADMIN_PASS
export OS_AUTH_URL=http://$CONTROLLER:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
export OS_AUTH_TYPE=password
EOF

cat <<EOF >$PWD/demo-openrc.sh
#!/bin/bash
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=$DEMO_PASS
export OS_AUTH_URL=http://$CONTROLLER:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
export OS_AUTH_TYPE=password
EOF

#ceilometer:
openstack user create --domain default --password $CEILOMETER_PASS ceilometer
openstack role add --project service --user ceilometer admin
openstack service create --name ceilometer --description "Telemetry" metering
openstack endpoint create --region RegionOne metering public http://$CONTROLLER:8777
openstack endpoint create --region RegionOne metering internal http://$CONTROLLER:8777
openstack endpoint create --region RegionOne metering admin http://$CONTROLLER:8777

#glance
openstack user create --domain default --password $GLANCE_PASS glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://$CONTROLLER:9292
openstack endpoint create --region RegionOne image internal http://$CONTROLLER:9292
openstack endpoint create --region RegionOne image admin http://$CONTROLLER:9292





