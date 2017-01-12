FROM centos:7

ADD ./CentOS7-Base.repo /etc/yum.repos.d/CentOS-Base.repo
ADD ./setup.sh /home/setup.sh

RUN yum clean all
RUN yum makecache

RUN yum install -y openstack-glance

CMD /usr/bin/python2.7 /usr/bin/glance-api --config-file /etc/glance/glance-api.conf

