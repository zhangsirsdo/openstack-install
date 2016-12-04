#!/bin/bash

RDO_REPO_PKG=https://repos.fedorapeople.org/repos/openstack/openstack-mitaka/rdo-release-mitaka-6.noarch.rpm
rpm -q rdo-release-mitaka || {
    rpm -Uvh $RDO_REPO_PKG && yum update -y
}

