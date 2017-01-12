#!/bin/bash

openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token $ADMIN_TOKEN
openstack-config --set /etc/keystone/keystone.conf DEFAULT debug true
openstack-config --set /etc/keystone/keystone.conf DEFAULT log_date_format %Y-%m-%d %H:%M:%S
openstack-config --set /etc/keystone/keystone.conf token provider fernet
openstack-config --set /etc/keystone/keystone.conf database connection "mysql+pymysql://keystone:$KEYSTONE_DBPASS@$MYSQL_IP/keystone"

su -s /bin/sh -c "keystone-manage db_sync" keystone

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone

cat <<EOF >/home/os-openrc.sh
#!/bin/bash
export OS_TOKEN=$ADMIN_TOKEN
export OS_URL=http://$CONTROLLER:35357/v3
export OS_IDENTITY_API_VERSION=3
EOF

keystone-all --config-file /etc/keystone/keystone.conf
