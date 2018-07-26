## K8S-Mirrors

通过Travis CI自动触发拉取官方k8s镜像并推送到阿里云容器镜像仓库

![build](https://travis-ci.org/Mr-Linus/k8s-mirrors.svg?branch=master)

#### 目前同步的k8s版本:V1.11.0

本仓库拉取只需修改镜像仓库地址由`k8s.gcr.io`修改为`registry.cn-hangzhou.aliyuncs.com/geekcloud`,整个过程无需翻墙
你也可以使用本项目中的`k8s-images.sh`脚本,修改最后几行:
```bash
#server
pull_images
set_tags
push_images

#local

#local_pull_images
#reset_tags
```
修改为:
```bash
#server
#pull_images
#set_tags
#push_images

#local
local_pull_images
reset_tags
```
执行脚本即可实现容器镜像拉取
### Centos安装K8S前需要做的工作:
- 关闭swap
- 关闭selinux
- 关闭防火墙
- 集群里的每个节点的/etc/hosts都要有所有节点ip和与其对应的hostname
- docker安装完毕 
> 安装docker可以参考[docker安装脚本](https://github.com/Mr-Linus/shell-repo/blob/master/docker/docker_common.sh)
### 安装kubeadm
```bash
./install-kubeadm_el7.sh
```
### 主节点安装k8s
```bash
./install-k8s-master.sh
```
### 下面可以做什么:

 选择需要的集群网络方案:`flannel`或`calico`,安装脚本在`install-networks`目录下,如果你当前拉取速度过慢也可以考虑使用`calico-images.sh`脚本加速拉取


有任何问题欢迎issue!