### 文件说明
 - Dockerfile  
   用于构建docker镜像  

 - setup.sh  
   mariadb_setup容器的初始化脚本，用于创建数据，启动容器之后自动执行。  

### 使用说明
 - 构建镜像  
   进入到该目录下，执行docker build -t mariadb_setup:1 .  

 - 启动容器  
   进入到工程根目录，执行docker-compose up  

