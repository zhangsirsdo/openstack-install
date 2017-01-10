FROM centos:7

ADD ./CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo

RUN yum clean all
RUN yum makecache

RUN yum install -y openstack-ceilometer-api openstack-ceilometer-collector openstack-ceilometer-notification openstack-ceilometer-central python-ceilometerclient

CMD /usr/bin/python2 /usr/bin/ceilometer-collector --config-file /etc/ceilometer/ceilometer.conf

