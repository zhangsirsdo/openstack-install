#!/bin/bash

if [ "$INIT_DB" = "True" ];then
  /usr/bin/mysqladmin -u root password $MYSQL_ROOT_PASSWORD
  #keystone
  mysql -u root -p$DB_PASS -e "CREATE DATABASE keystone;"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$KEYSTONE_DBPASS';"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$KEYSTONE_DBPASS';"
  #glance
  mysql -u root -p$DB_PASS -e "CREATE DATABASE glance;"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$GLANCE_DBPASS';"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$GLANCE_DBPASS';"
  #nova
  mysql -u root -p$DB_PASS -e "CREATE DATABASE nova;"
  mysql -u root -p$DB_PASS -e "CREATE DATABASE nova_api;"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '$NOVA_DBPASS';"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '$NOVA_DBPASS';"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY '$NOVA_DBPASS';"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY '$NOVA_DBPASS';"
  #neutron
  mysql -u root -p$DB_PASS -e "CREATE DATABASE neutron;"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '$NEUTRON_DBPASS';"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '$NEUTRON_DBPASS';"
  #cinder
  mysql -u root -p$DB_PASS -e "CREATE DATABASE cinder;"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '$CINDER_DBPASS';"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY '$CINDER_DBPASS';"
  #manila
  mysql -u root -p$DB_PASS -e "CREATE DATABASE manila;"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON manila.* TO 'manila'@'localhost' IDENTIFIED BY '$MANILA_DBPASS';"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON manila.* TO 'manila'@'%' IDENTIFIED BY '$MANILA_DBPASS';"
  #heat
  mysql -u root -p$DB_PASS -e "CREATE DATABASE heat;"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'localhost' IDENTIFIED BY '$HEAT_DBPASS';"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'%' IDENTIFIED BY '$HEAT_DBPASS';"
  #trove
  mysql -u root -p$DB_PASS -e "CREATE DATABASE trove;"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON trove.* TO 'trove'@'localhost' IDENTIFIED BY '$TROVE_DBPASS';"
  mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON trove.* TO 'trove'@'%' IDENTIFIED BY '$TROVE_DBPASS';"
fi
