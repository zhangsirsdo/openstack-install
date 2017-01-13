FROM keystone:1

ADD ./keystone_init.sh /home/keystone_init.sh
RUN chmod 755 /home/keystone_init.sh

CMD ["/sbin/dumb-init","/home/keystone_init.sh"]
