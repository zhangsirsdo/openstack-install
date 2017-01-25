FROM centos:base

RUN yum install -y openstack-keystone openstack-utils python-openstackclient mariadb

ADD ./install.sh /home/install.sh
RUN chmod 755 /home/install.sh

CMD ["/sbin/dumb-init","/home/install.sh"]
