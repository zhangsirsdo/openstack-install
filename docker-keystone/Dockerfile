FROM centos:7

ADD ./CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo
ADD ./keystone_init.sh /home/keystone_init.sh
ADD ./keystone_install.sh /home/keystone_install.sh

RUN yum clean all
RUN yum makecache

RUN yum install -y openstack-keystone openstack-utils python-openstackclient

CMD sh /home/keystone_install.sh
