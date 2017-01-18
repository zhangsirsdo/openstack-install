#!/bin/bash

source ../etcd.conf
ADVERTISEMENT_URL=${ADVERTISEMENT_URL:=127.0.0.1:2379}

PROJECT_NAME=${PROJECT_NAME:=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/git/project_name|jq -r '.node.value'`}
PROJECT_PATH=${PROJECT_PATH:=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/git/project_path|jq -r '.node.value'`}
GIT_REPOS_PATH=${GIT_REPOS_PATH:=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/git/repos_path|jq -r '.node.value'`}
GIT_HTTP_PORT=${GIT_HTTP_PORT:=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/git/http_port|jq -r '.node.value'`}
REGISTRY_PORT=${REGISTRY_PORT:=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/registry/port|jq -r '.node.value'`}

PROJECT_NAME=${PROJECT_NAME:=openstack-install}
PROJECT_PATH=${PROJECT_PATH:=/home/$PROJECT_NAME.zip}
GIT_REPOS_PATH=${GIT_REPOS_PATH:=/home/git_repos}
GIT_HTTP_PORT=${GIT_HTTP_PORT:=8088}
REGISTRY_PORT=${REGISTRY_PORT:=5050}

GIT_HOST=${GIT_HOST:=`echo $ADVERTISEMENT_URL|awk -F ':' '{print $1}'`}
REGISTRY_HOST=${REGISTRY_HOST:=`echo $ADVERTISEMENT_URL|awk -F ':' '{print $1}'`}

# start container of git server
cp openstack_git_compose_template.yml openstack_git_compose.ymL
sed -i "s/GIT_HTTP_PORT/$GIT_HTTP_PORT/g" openstack_git_compose.yml
sed -i "s/GIT_REPOS_PATH/$GIT_REPOS_PATH/g" openstack_git_compose.yml
docker-compose -f ./openstack_git_compose.yml up -d

# save configuration of git to etcd
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/git/host -d value="$GIT_HOST"

# establish openstack-install.git and put code to it
mkdir -p $GIT_REPOS_PATH
git init $GIT_REPOS_PATH/$PROJECT_NAME.git
cp $PROJECT_PATH $GIT_REPOS_PATH/$PROJECT_NAME.git
unzip $GIT_REPOS_PATH/$PROJECT_NAME.git/$PROJECT_NAME.zip
rm -f $GIT_REPOS_PATH/$PROJECT_NAME.git/$PROJECT_NAME.zip
cd $GIT_REPOS_PATH/$PROJECT_NAME.git
git add .
git commit -m "initialize the openstack-install.git"

# start container of registry
cp openstack_registry_compose_template.yml openstack_registry_compose.yml
sed -i "s/REGISTRY_PORT/$REGISTRY_PORT/g" openstack_registry_compose.yml
docker-compose -f ./openstack_registry_compose.yml up -d

# save configuration of registry to etcd
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/registry/host -d value="$REGISTRY_HOST"

# todo:yaml source container


