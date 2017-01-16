#!/bin/bash

#globals
DB_HOST=${DB_HOST:=localhost}
DB_PORT=${DB_PORT:=3306}
DB_USER=${DB_USER:=root}
DB_PASS=${DB_PASS:=root}
KEYSTONE_DB_PASS=${KEYSTONE_DB_PASS:=$DB_PASS}
GLANCE_DB_PASS=${GLANCE_DB_PASS:=$DB_PASS}
NOVA_DB_PASS=${NOVA_DB_PASS:=$DB_PASS}
NEUTRON_DB_PASS=${NEUTRON_DB_PASS:=$DB_PASS}
CINDER_DB_PASS=${CINDER_DB_PASS:=$DB_PASS}

#detect where the service of mariadb is ok
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "select version();" &>/dev/null
while [ $? -ne 0 ]
do
  sleep 1
  mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "select version();" &>/dev/null
done

# create database of keystone
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "CREATE DATABASE IF NOT EXISTS keystone;"
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$KEYSTONE_DB_PASS';"
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$KEYSTONE_DB_PASS';"

# create database of glance
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "CREATE DATABASE IF NOT EXISTS glance;"
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$GLANCE_DB_PASS';"
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$GLANCE_DB_PASS';"

# create database of nova and nova_api
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "CREATE DATABASE IF NOT EXISTS nova;"
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "CREATE DATABASE IF NOT EXISTS nova_api;"
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '$NOVA_DB_PASS';"
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '$NOVA_DB_PASS';"
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY '$NOVA_DB_PASS';"
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY '$NOVA_DB_PASS';"

# create database of neutron
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "CREATE DATABASE IF NOT EXISTS neutron;"
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '$NEUTRON_DB_PASS';"
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '$NEUTRON_DB_PASS';"

# create database of cinder
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "CREATE DATABASE IF NOT EXISTS cinder;"
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '$CINDER_DB_PASS';"
mysql -h $DB_HOST -u$DB_USER -p$DB_PASS -P$DB_PORT -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY '$CINDER_DB_PASS';"

