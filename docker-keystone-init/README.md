### 文件说明
 - Dockerfile  
   用于构建docker镜像  

 - keystone_init.sh  
   keystone_init容器初始化脚本。容器启动之后自动执行，完成创建服务endpoint和user。  

### 使用说明
 - 构建镜像  
   进入到该目录下，执行docker build -t keystone_init:1 .  

 - 启动容器  
   进入到该工程根目录下，执行docker-compose up  
