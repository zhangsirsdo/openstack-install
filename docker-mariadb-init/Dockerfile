FROM centos:base

ADD ./mariadb_init.sh /home/mariadb_init.sh
RUN chmod 755 /home/mariadb_init.sh

RUN yum install -y mariadb 

CMD ["/sbin/dumb-init","/home/mariadb_init.sh"]
