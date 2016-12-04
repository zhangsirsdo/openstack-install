#!/bin/bash

source $PWD/env.sh

# Install the packages
yum install -y mariadb mariadb-server python2-PyMySQL

grep "character-set-server = utf8" /etc/my.cnf || {
cat ＜＜ EOF >>/etc/my.cnf
[mysqld]
default-storage-engine = innodb
innodb_file_per_table
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
EOF
}

# Start the database service and configure it to start when the system boots:
systemctl enable mariadb.service
systemctl start mariadb.service
# Secure the database service by running the mysql_secure_installation script. 
# In particular, choose a suitable password for the database root account.
mysql_secure_installation
