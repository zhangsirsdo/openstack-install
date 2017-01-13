### 文件说明
 - Dockerfile  
   用于构建docker镜像 

 - CentOS7-Base.repo  
   163的repo文件，用于下载openstack组件安装包  

 - dumb-init_1.0.0_amd64  
   Docker容器初始化工具  

### 使用说明
 - 构建镜像  
   该镜像是基于centos7，作为其他docker镜像的base镜像使用。构建该镜像时，需要进入到该目录下，执行docker build -t centos:base .  
