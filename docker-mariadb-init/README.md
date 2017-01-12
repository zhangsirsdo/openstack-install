### 文件说明
 - CentOS7-Base.repo  
   163的repo文件，用于下载openstack组件安装包  

 - Dockerfile  
   用于构建docker镜像  

 - mariadb_init.sh  
   mariadb容器的初始化脚本，用于创建数据，启动容器之后自动执行。  

### 使用说明
 - 构建镜像  
   进入到该目录下，执行docker build -t mariadbinit:latest .  

 - 启动容器  
   进入到工程根目录，执行docker-compose up  

