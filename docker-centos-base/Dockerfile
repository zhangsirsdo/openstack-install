FROM centos:7

ADD ./CentOS7-Base.repo /etc/yum.repos.d/CentOS-Base.repo
RUN yum clean all
RUN yum makecache

ADD ./dumb-init_1.0.0_amd64 /sbin/dumb-init
RUN chmod +x /sbin/dumb-init
