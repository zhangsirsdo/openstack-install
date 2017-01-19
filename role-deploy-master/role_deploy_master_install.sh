#!/bin/bash

ADVERTISEMENT_URL=`cat ../global.conf |grep ADVERTISEMENT_URL|awk -F '=' '{print $2}'`
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
REGISTRY_PATH=${REGISTRY_PATH:=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/registry/path|jq -r '.node.value'`}
IMAGES_PACKAGE_NAME=${IMAGES_PACKAGE_NAME:=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/registry/images_package_name|jq -r '.node.value'`}
YUM_HTTP_PORT=${YUM_HTTP_PORT:=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/yum/http_port|jq -r '.node.value'`}
YUM_REPO_PATH=${YUM_REPO_PATH:=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/yum/repo_path|jq -r '.node.value'`}
RPMS_PACKAGE_NAME=${RPMS_PACKAGE_NAME:=`curl -L -XGET \
  http://$ADVERTISEMENT_URL/v2/keys/endpoints/yum/rpms_package_name|jq -r '.node.value'`}

PROJECT_NAME=${PROJECT_NAME:=openstack-install}
PROJECT_PATH=${PROJECT_PATH:=/home/$PROJECT_NAME.zip}
GIT_REPOS_PATH=${GIT_REPOS_PATH:=/home/git_repos}
GIT_HTTP_PORT=${GIT_HTTP_PORT:=8088}
REGISTRY_PORT=${REGISTRY_PORT:=5050}
REGISTRY_PATH=${REGISTRY_PATH:=/home/registry}
IMAGES_PACKAGE_NAME=${IMAGES_PACKAGE_NAME:=docker_images.zip}
YUM_HTTP_PORT=${YUM_HTTP_PORT:=8086}
YUM_REPO_PATH=${YUM_REPO_PATH:=/home/yum_repos}
RPMS_PACKAGE_NAME=${RPMS_PACKAGE_NAME:=rpm_package.zip}

GIT_HOST=${GIT_HOST:=`echo $ADVERTISEMENT_URL|awk -F ':' '{print $1}'`}
REGISTRY_HOST=${REGISTRY_HOST:=`echo $ADVERTISEMENT_URL|awk -F ':' '{print $1}'`}
YUM_HOST=${REGISTRY_HOST:=`echo $ADVERTISEMENT_URL|awk -F ':' '{print $1}'`}

pwd=`pwd`
# start container of git server
cp openstack_git_compose_template.yml openstack_git_compose.yml
sed -i "s#GIT_HTTP_PORT#$GIT_HTTP_PORT#g" openstack_git_compose.yml
sed -i "s#GIT_REPOS_PATH#$GIT_REPOS_PATH#g" openstack_git_compose.yml
docker-compose -f ./openstack_git_compose.yml up -d
rm -f openstack_git_compose.yml
# save configuration of git to etcd
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/git/host -d value="$GIT_HOST"
# establish openstack-install.git and put code to it
mkdir -p $GIT_REPOS_PATH
git init $GIT_REPOS_PATH/$PROJECT_NAME.git
cp $PROJECT_PATH $GIT_REPOS_PATH/$PROJECT_NAME.git
unzip $GIT_REPOS_PATH/$PROJECT_NAME.git/$PROJECT_NAME.zip -d $GIT_REPOS_PATH/$PROJECT_NAME.git
rm -f $GIT_REPOS_PATH/$PROJECT_NAME.git/$PROJECT_NAME.zip
cd $GIT_REPOS_PATH/$PROJECT_NAME.git
git add .
git commit -m "initialize the openstack-install.git"


# put docker images to registry path and then map it into container
mkdir -p $REGISTRY_PATH
cp $GIT_REPOS_PATH/$PROJECT_NAME.git/$IMAGES_PACKAGE_NAME $REGISTRY_PATH
unzip $REGISTRY_PATH/$IMAGES_PACKAGE_NAME -d $REGISTRY_PATH
rm -f $REGISTRY_PATH/$IMAGES_PACKAGE_NAME
# start container of registry
cd $pwd
cp openstack_registry_compose_template.yml openstack_registry_compose.yml
sed -i "s#REGISTRY_PORT#$REGISTRY_PORT#g" openstack_registry_compose.yml
sed -i "s#REGISTRY_PATH#$REGISTRY_PATH#g" openstack_registry_compose.yml
docker-compose -f ./openstack_registry_compose.yml up -d
rm -f openstack_registry_compose.yml
# save configuration of registry to etcd
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/registry/host -d value="$REGISTRY_HOST"


# put rpms to yum repo path and then map it into container
mkdir -p $YUM_REPO_PATH
cp $GIT_REPOS_PATH/$PROJECT_NAME.git/$RPMS_PACKAGE_NAME $YUM_REPO_PATH
unzip $YUM_REPO_PATH/$RPMS_PACKAGE_NAME -d $YUM_REPO_PATH
rm -f $YUM_REPO_PATH/$RPMS_PACKAGE_NAME
# start container of yum
cd $pwd
cp openstack_yum_compose_template.yml openstack_yum_compose.yml
sed -i "s#YUM_HTTP_PORT#$YUM_HTTP_PORT#g" openstack_yum_compose.yml
sed -i "s#YUM_REPO_PATH#$YUM_REPO_PATH#g" openstack_yum_compose.yml
docker-compose -f ./openstack_yum_compose.yml up -d
rm -f openstack_yum_compose.yml
# save configuration of yum to etcd
curl -L -XPUT http://$ADVERTISEMENT_URL/v2/keys/endpoints/yum/host -d value="$YUM_HOST"
