## K8S-Mirrors

通过Travis CI自动触发拉取官方k8s镜像并推送到阿里云容器镜像仓库

![build](https://travis-ci.org/Mr-Linus/k8s-mirrors.svg?branch=master)

### 原理

利用境外Travis CI服务器协助我们拉取gcr.io的镜像,打上tag并推送至阿里云,实现容器镜像的境内mirrors

#### 目前同步的k8s版本:V1.11.0 V1.12.5 v1.13.3
- 2018.8.15 已同步 dashboard 镜像
- 2018.9.1 已同步 ingress-nginx 镜像

### 如何使用 
- 方法一：运行容器拉取指定镜像
#### 版本V1.13.3
```shell
docker run --rm -it \
        -v /var/run/docker.sock:/var/run/docker.sock  \
        registry.cn-hangzhou.aliyuncs.com/geekcloud/image-pull:k8s-1.13.3
```
#### 版本V1.12.5
```shell
docker run --rm -it \
        -v /var/run/docker.sock:/var/run/docker.sock  \
        registry.cn-hangzhou.aliyuncs.com/geekcloud/image-pull:k8s-1.12.5
```
- 方法二：运行脚本拉取镜像(V1.12.5)
整个过程无需翻墙,只需修改脚本`k8s-images.sh`最后几行,
将:
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

### Centos 7使用kubdeadm安装K8S前需要做的工作:
- 关闭swap
- 关闭selinux
- 关闭防火墙
- 集群里的每个节点的/etc/hosts都要有所有节点ip和与其对应的hostname
- docker安装完毕 
- 让系统内核开启网络转发

> 安装docker可以参考[docker安装脚本](https://github.com/Mr-Linus/shell-repo/blob/master/docker/docker_common.sh)
>
> 不要瞎看网上的教程,kubeadm安装不同于二进制安装,只需安装必须的kubeadm和kubelet等组件,其他如etcd等服务都是通过kubeadm自动创建,无需自行安装!

### 安装kubeadm

```bash
./install-generic/install-kubeadm_el7.sh
```
> 安装脚本附带详细注释,安装出现任何疑问可以查看

### 拉取镜像
- 如果你的机器可以翻越GFW,请忽略本步骤
- 如果你的机器不能翻越GFW,请先执行[拉取镜像](#如何使用)

#### 需要注意的是,每个节点无论是工作节点还是master节点都需要拉取镜像!! 
#### 否则将会出现pod一直处于pending或者构建镜像的状态!! 

### 主节点安装k8s
```bash
./install-generic/install-k8s-master.sh
```
> 这个时候节点join进来并不会ready,需要你安装网络组件
>
> 安装脚本附带详细注释,安装出现任何疑问可以查看
### 下面可以做什么:

- 部署 CNI
选择需要的集群网络方案:`flannel`或`calico`,安装脚本在`install-networks`目录下,如果你当前拉取速度过慢也可以考虑使用`network-images.sh`脚本加速拉取镜像
同样的,修改最后几行,
将
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
- 部署 ingress-nginx 
拉取脚本存于[/ingress-nginx](/ingress-nginx),使用方法同上

本项目致力于搭建完整的 K8S 平台，如果需要其他额外镜像，您可以使用[张馆长大佬](https://github.com/zhangguanzhang) 提供的脚本。
假设需要拉取gcr.io/google_containers/pause:3.0

```
curl -s https://www.zhangguanzhang.com/pull | bash -s -- gcr.io/google_containers/pause:3.0
```

### 有任何问题欢迎issue!

![img-source-from-https://github.com/docker/dockercraft](https://github.com/docker/dockercraft/raw/master/docs/img/contribute.png?raw=true)