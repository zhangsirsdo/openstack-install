### 文件说明
 - CentOS7-Base-163.repo  
   163的repo文件，用于下载openstack组件安装包  

 - Dockerfile  
   用于构建docker镜像  

 - mariadb_install.sh  
   mariadb容器的部署脚本，启动容器之后自动执行。功能包含修改配置文件和启动mysql进程  

 - mariadb_init.sh 
   mariadb容器初始化脚本。待容器启动之后，需要进入到容器中，执行该脚本，完成mariadb初始化。  
   进入指定容器：docker exec -it <container id> bash  
   初始化mariadb：sh /home/mariadb_init.sh  
