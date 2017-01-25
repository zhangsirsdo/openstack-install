
openstack-install部署流程：  

1.部署initiator节点，即整个系统的初始化节点。该节点上部署initiator角色，包含etcd-discovery,registry,yum,dhcp和git服务。  

2.安装其他节点的操作系统，从initiator节点上的dhcp服务获取ip，之后手动执行node_initiator.sh脚本。在该脚本中，下载必要rpm包，下载etcd镜像，启动etcd的容器，并向initiator节点上的etcd-discovery进行注册，加入etcd集群。对某些key（主要是ip相关的key）进行watch，当监测到对应的value变化时，触发角色部署流程（pull 对应角色的安装脚本，并进行安装）。  

3.在etcd中确定节点和role的关系，从而触发上一步中的value变化，从而完成部署。  

4.重复第2步和第3步，直到所有节点部署完成。  
