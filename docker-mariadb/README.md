### 文件说明
 - CentOS7-Base.repo  
   163的repo文件，用于下载openstack组件安装包  

 - Dockerfile  
   用于构建docker镜像  

 - mariadb_install.sh  
   mariadb容器的部署脚本，启动容器之后自动执行。功能包含修改配置文件和启动mysql进程  

 - mariadb_init.sh   
   mariadb容器初始化脚本。待容器启动之后，需要执行该脚本，完成mariadb初始化。  
### 使用说明
 - 构建镜像  
   进入到该目录下，执行docker build -t mariadb_test:1 .

 - 启动容器
   进入到该目录下，执行docker-compose up

 - mariadb初始化
   容器启动之后，执行初始化脚本  
   docker exec -it &lt;container id&gt; sh /home/mariadb_init.sh 
 
