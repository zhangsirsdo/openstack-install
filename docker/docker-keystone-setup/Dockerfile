FROM keystone:1

ADD ./setup.sh /home/setup.sh
RUN chmod 755 /home/setup.sh

CMD ["/sbin/dumb-init","/home/setup.sh"]
