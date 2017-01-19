#!/bin/bash

ADVERTISEMENT_URL=`cat ../global.conf |grep ADVERTISEMENT_URL|awk -F '=' '{print $2}'|awk -F ':' '{print $1}'`
ADVERTISEMENT_URL=${ADVERTISEMENT_URL:=127.0.0.1}
NAME=${NAME:=etcd1}
TOKEN=${TOKEN:=etcd-cluster-1}
STATE=${STATE:=new}
PEER_PORT=${PEER_PORT:=2380}
CLIENT_PORT=${CLIENT_PORT:=2379}

# start container of etcd
cp openstack_etcd_compose_template.yml openstack_etcd_compose.yml
sed -i "s#PEER_PORT#$PEER_PORT#g" openstack_etcd_compose.yml
sed -i "s#CLIENT_PORT#$CLIENT_PORT#g" openstack_etcd_compose.yml
sed -i "s#NAME_VAR#$NAME#g" openstack_etcd_compose.yml
sed -i "s#ADVERTISEMENT_HOST#$ADVERTISEMENT_URL#g" openstack_etcd_compose.yml
sed -i "s#STATE_VAR#$STATE#g" openstack_etcd_compose.yml
sed -i "s#TOKEN_VAR#$TOKEN#g" openstack_etcd_compose.yml

docker-compose -f ./openstack_etcd_compose.yml up -d
rm -f openstack_etcd_compose.yml
