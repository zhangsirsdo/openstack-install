
The link of map between host and roles is here:[host_roles_map](HOST_ROLE_MAP.MD)

### Roles 
 - Database Master/Slave(Mysql)
 - Message Queue Master/Slave(Rabbitmq)
 - Mongodb Master/Slave
 - Memcached
 - OpenStack Controller (Nova, Cinder, Keystone, Glance, Ceilometer)
 - OpenStack Compute Node
 - OpenStack Network Node
 - OpenStack Cinder Node

### Prerequisites
 - A git service
 - A build & packaging service
 - RPM repo mirrors (CentOS, EPEL, RDO...)

### Cluster Management
 - Cluster is maintained by an etcd config database;
 - Cluster peers will typically reuse 3 OpenStack Controller nodes;
 - Other nodes will use etcd client api to periodically update their status in config db;

### Role Deployment
 - Admin is allowed to define the role for a node in config db; 
 - When a node is advertising itself in the cluster, it will pull its config and deloy them on its own;

### Services Design
 - Etcd service, typically reuse 3 OpenStack Controller nodes as peers;
 - Nginx LB service, acting as API load balancer in front of OpenStack controller cluster;
 - Controller service, providing Nova, Cinder, Glance, Keystone, Ceilometer API services;
 - Database service, a failover mysql cluster, see https://dev.mysql.com/doc/refman/5.7/en/mysql-cluster-replication-failover.html;
 - Rabbitmq service, a failover rabbitmq cluster, see https://www.rabbitmq.com/clustering.html;
 - Memcached service, a memcahced cluster;
 - Mongodb service, a failover mongodb cluster, see https://docs.mongodb.com/manual/replication/;
 - Compute service, a set of compute nodes providing VMs;
 - Network service, providing vpc, fip, vrouter services;
