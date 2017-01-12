#!/bin/bash

touch /etc/my.cnf.d/openstack.cnf
openstack-config --set /etc/my.cnf.d/openstack.cnf mysqld bind-address $BIND_ADDRESS
openstack-config --set /etc/my.cnf.d/openstack.cnf mysqld default-storage-engine innodb
openstack-config --set /etc/my.cnf.d/openstack.cnf mysqld innodb_file_per_table
openstack-config --set /etc/my.cnf.d/openstack.cnf mysqld max_connections 4096
openstack-config --set /etc/my.cnf.d/openstack.cnf mysqld collation-server utf8_general_ci
openstack-config --set /etc/my.cnf.d/openstack.cnf mysqld character-set-server utf8

mysql_install_db --user=mysql --ldata=/var/lib/mysql/ --basedir=/usr
mysqld_safe --defaults-file=/etc/my.cnf.d/openstack.cnf --datadir=/var/lib/mysql/
