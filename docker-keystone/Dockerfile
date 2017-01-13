FROM centos:base

RUN yum install -y openstack-keystone openstack-utils python-openstackclient

ADD ./keystone_install.sh /home/keystone_install.sh
RUN chmod 755 /home/keystone_install.sh

CMD ["/sbin/dumb-init","/home/keystone_install.sh"]
