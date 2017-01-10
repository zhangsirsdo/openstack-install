FROM centos:7

ADD ./CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo
ADD ./setup.sh /home/setup.sh

RUN yum clean all
RUN yum makecache

RUN yum install -y openstack-glance

CMD /usr/bin/python2.7 /usr/bin/glance-registry --config-file /etc/glance/glance-registry.conf

