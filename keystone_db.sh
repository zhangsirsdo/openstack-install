#!/bin/bash

source $PWD/env.sh

mysql -p$DB_PASS -u root -e "CREATE DATABASE keystone;"
mysql -p$DB_PASS -u root -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
  IDENTIFIED BY '$KEYSTONE_DBPASS';"
mysql -p$DB_PASS -u root -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
  IDENTIFIED BY '$KEYSTONE_DBPASS';"

