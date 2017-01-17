#!/bin/bash

ADVERTISEMENT_URL=${ADVERTISEMENT_URL:=127.0.0.1}
NAME=${NAME:=etcd1}
TOKEN=${TOKEN:=etcd-cluster-1}
STATE=${STATE:=new}
cat <<EOF >./openstack_etcd_compose.yml
version: '2'
services:
  etcd:
    image: 'quay.io/coreos/etcd:v2.2.5'
    network_mode: "bridge"
    ports:
        - "2380:2380"
        - "2379:2379"
    environment:
        - ETCD_NAME=$NAME
        - ETCD_INITIAL_ADVERTISE_PEER_URLS=http://$ADVERTISEMENT_URL:2380
        - ETCD_LISTEN_PEER_URLS=http://$ADVERTISEMENT_URL:2380
        - ETCD_ADVERTISE_CLIENT_URLS=http://$ADVERTISEMENT_URL:2379
        - ETCD_LISTEN_CLIENT_URLS=http://$ADVERTISEMENT_URL:2379
        - ETCD_INITIAL_CLUSTER=$NAME=http://$ADVERTISEMENT_URL:2380
        - ETCD_INITIAL_CLUSTER_STATE=$STATE
        - ETCD_INITIAL_CLUSTER_TOKEN=$TOKEN
EOF

docker-compose -f ./openstack_etcd_compose.yml up -d
