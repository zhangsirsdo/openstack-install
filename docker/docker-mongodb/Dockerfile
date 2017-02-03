FROM centos:7

ADD ./CentOS7-Base.repo /etc/yum.repos.d/CentOS-Base.repo
ADD ./setup.sh /home/setup.sh

RUN yum clean all
RUN yum makecache

RUN yum install -y mongodb-server mongodb
RUN mkdir -p /data/db

CMD /usr/bin/mongod

