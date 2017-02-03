FROM centos:base

ADD ./setup.sh /home/setup.sh
RUN chmod 755 /home/setup.sh

RUN yum install -y mariadb 

CMD ["/sbin/dumb-init","/home/setup.sh"]
