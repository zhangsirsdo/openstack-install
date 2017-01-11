FROM centos:7

ADD ./CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo
ADD ./db_setup.sh /home/db_setup.sh
ADD ./db_init.sh /home/db_init.sh

RUN yum clean all
RUN yum makecache

RUN yum install -y mariadb mariadb-server python2-PyMySQL openstack-utils

CMD sh /home/db_setup.sh
