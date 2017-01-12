FROM centos:7

ADD ./CentOS7-Base.repo /etc/yum.repos.d/CentOS-Base.repo
ADD ./mariadb_init.sh /home/mariadb_init.sh
ADD ./mariadb_install.sh /home/mariadb_install.sh

RUN yum clean all
RUN yum makecache

RUN yum install -y mariadb mariadb-server python2-PyMySQL openstack-utils

CMD sh /home/mariadb_install.sh
