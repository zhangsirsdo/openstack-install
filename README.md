### Roles 
 - Database (Mysql)
 - Message Queue (Rabbitmq)
 - Memcached
 - OpenStack Controller (Nova, Cinder, Keystone, Glance, Ceilometer)
 - OpenStack Compute Node
 - OpenStack Network Node
 - OpenStack Cinder Node


### Prerequisites
 - git service
 - build & packaging service
 - RPM repo mirrors (CentOS, EPEL, RDO...)

### Cluster Management
 1. Cluster config is maintained in an etcd config database;
 2. Cluster peers willtypically reuse 3 OpenStack Controller nodes.
 3. Other nodes will use etcd client api to periodically update their status in config db.
 4. Admin is allowed to define the role for a node in config db; 
 5. When a node is advertising itself in the cluster, it will be installed and configured according to its pre-defined role.
