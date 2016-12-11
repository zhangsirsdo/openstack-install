#!/bin/bash

source $PWD/env.sh

mysql -p$DB_PASS -u root -e "CREATE DATABASE nova_api;"
mysql -p$DB_PASS -u root -e "CREATE DATABASE nova;"
mysql -p$DB_PASS -u root -e "GRANT ALL PRIVILEGES ON \
        nova_api.* TO 'nova'@'localhost' IDENTIFIED BY '$NOVA_DBPASS';"
mysql -p$DB_PASS -u root -e "GRANT ALL PRIVILEGES ON \
        nova_api.* TO 'nova'@'%' IDENTIFIED BY '$NOVA_DBPASS';"
mysql -p$DB_PASS -u root -e "GRANT ALL PRIVILEGES ON \
        nova.* TO 'nova'@'localhost' IDENTIFIED BY '$NOVA_DBPASS';"
mysql -p$DB_PASS -u root -e "GRANT ALL PRIVILEGES ON \
        nova.* TO 'nova'@'%' IDENTIFIED BY '$NOVA_DBPASS';"
