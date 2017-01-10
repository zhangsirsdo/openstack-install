#!/bin/bash

source /home/config.sh
source $PWD/env.sh

mysql -h $MYSQL_IP -u root -p$DB_PASS -e "CREATE DATABASE keystone;"
mysql -h $MYSQL_IP -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
  IDENTIFIED BY '$KEYSTONE_DBPASS';"
mysql -h $MYSQL_IP -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
  IDENTIFIED BY '$KEYSTONE_DBPASS';"

mysql -h $MYSQL_IP -u root -p$DB_PASS -e "CREATE DATABASE glance;"
mysql -h $MYSQL_IP -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'10.229.43.217' \
  IDENTIFIED BY '$GLANCE_DBPASS';"
mysql -h $MYSQL_IP -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
  IDENTIFIED BY '$GLANCE_DBPASS';"

