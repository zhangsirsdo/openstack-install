#!/bin/bash

source $PWD/env.sh

mysql -p$DB_PASS -u root -e "CREATE DATABASE glance;"
mysql -p$DB_PASS -u root -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
  IDENTIFIED BY '$GLANCE_DBPASS';"
mysql -p$DB_PASS -u root -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
  IDENTIFIED BY '$GLANCE_DBPASS';"
