#!/bin/bash

GITLAB_HTTP_PORT=${GITLAB_HTTP_PORT:=8088}
GITLAB_SSH_PORT=${GITLAB_SSH_PORT:=1022}
GITLAB_HTTPS_PORT=${GITLAB_HTTPS_PORT:=446}
REGISTRY_PORT=${REGISTRY_PORT:=5000}

cat <<EOF >./openstack_gitlab_compose.yml
version: '2'
services:
  gitlab:
    image: 'gitlab/gitlab-ce:8.13.11-ce.0'
    network_mode: "bridge"
    ports:
        - '$GITLAB_HTTP_PORT:80'
        - '$GITLAB_SSH_PORT:22'
        - '$GITLAB_HTTPS_PORT:443'
    volumes:
        - '/srv/gitlab/openstack-install/config:/etc/gitlab'
        - '/srv/gitlab/openstack-install/logs:/var/log/gitlab'
        - '/srv/gitlab/openstack-install/data:/var/opt/gitlab'
EOF
docker-compose -f ./openstack_gitlab_compose.yml up -d

cat <<EOF >./openstack_registry_compose.yml
version: '2'
services:
  registry:
    image: 'registry:2'
    network_mode: "host"
    ports:
        - "$REGISTRY_PORT:5000"
#    environment:
EOF
docker-compose -f ./openstack_registry_compose.yml up -d
