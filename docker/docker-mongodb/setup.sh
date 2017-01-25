mongo --host '10.229.43.217' --eval 'db = db.getSiblingDB("ceilometer");db.createUser({user: "ceilometer",pwd: "redhat",roles: [ "readWrite", "dbAdmin" ]})'
