#!/bin/bash

source $PWD/env.sh

mysql -h $MYSQL_IP -u root -p$DB_PASS -e "CREATE DATABASE keystone;"
mysql -h $MYSQL_IP -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
  IDENTIFIED BY '$KEYSTONE_DBPASS';"
mysql -h $MYSQL_IP -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
  IDENTIFIED BY '$KEYSTONE_DBPASS';"
