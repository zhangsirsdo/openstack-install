FROM centos:7

ADD ./CentOS7-Base.repo /etc/yum.repos.d/CentOS-Base.repo
ADD ./mariadb_init.sh /home/mariadb_init.sh

RUN yum clean all
RUN yum makecache

RUN yum install -y mariadb 

CMD sh /home/mariadb_init.sh
