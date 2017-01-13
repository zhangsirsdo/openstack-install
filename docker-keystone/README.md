### 文件说明
 - Dockerfile  
   用于构建docker镜像 

 - keystone_install.sh  
   keystone容器的部署脚本，启动容器之后自动执行。功能包含修改配置文件、keystone数据库建表和启动keystone进程  

### 使用说明
 - 构建镜像  
   进入到该目录下，执行docker build -t keystone:1 .  

 - 启动容器  
   进入到该工程根目录下，执行docker-compose up  
