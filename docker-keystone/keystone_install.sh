#!/bin/bash
source /home/config.sh
ADMIN_TOKEN=016f77abde58da9c724b
source $PWD/env.sh

#chmod 777 /var/log/keystone/keystone.log
su -s /bin/sh -c "keystone-manage db_sync" keystone

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone

cat <<EOF >$PWD/os-openrc.sh
#!/bin/bash
export OS_TOKEN=$ADMIN_TOKEN
export OS_URL=http://$CONTROLLER:35357/v3
export OS_IDENTITY_API_VERSION=3
EOF
