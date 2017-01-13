#!/bin/bash

ADMIN_TOKEN=${ADMIN_TOKEN:=016f77abde58da9c724b}
KEYSTONE_DB_PASS=${KEYSTONE_DB_PASS:=redhat}
DB_HOST=${DB_HOST:=localhost}
KEYSTONE_INIT=${KEYSTONE_INIT:=False}
ENDPOINT=${ENDPOINT:=127.0.0.1}
ADMIN_PASS=${ADMIN_PASS:=root}
DEMO_PASS=${DEMO_PASS:=redhat}

openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token $ADMIN_TOKEN
openstack-config --set /etc/keystone/keystone.conf DEFAULT debug true
openstack-config --set /etc/keystone/keystone.conf DEFAULT log_date_format "%Y-%m-%d %H:%M:%S"
openstack-config --set /etc/keystone/keystone.conf token provider fernet
openstack-config --set /etc/keystone/keystone.conf database connection "mysql+pymysql://keystone:$KEYSTONE_DB_PASS@$DB_HOST/keystone"

if [ "$KEYSTONE_INIT" = "True" ];then
  su -s /bin/sh -c "keystone-manage db_sync" keystone
  keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
fi

cat <<EOF >/home/demo-openrc.sh
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

keystone-all --config-file /etc/keystone/keystone.conf
