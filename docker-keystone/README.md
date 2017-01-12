### 文件说明
 - CentOS7-Base-163.repo  
   163的repo文件，用于下载openstack组件安装包  

 - Dockerfile  
   用于构建docker镜像  

 - keystone_install.sh  
   keystone容器的部署脚本，启动容器之后自动执行。功能包含修改配置文件、keystone数据库建表和启动keystone进程  

 - keystone_init.sh  
   keystone容器初始化脚本。待容器启动之后，需要进入到容器中，执行该脚本，完成keystone初始化。  
   进入指定容器：docker exec -it &lt;container id&gt; bash  
   初始化keystone：sh /home/keystone_init.sh  
