## K8S-Mirrors

通过Travis CI自动触发拉取官方k8s镜像并推送到阿里云容器镜像仓库

![build](https://travis-ci.org/Mr-Linus/k8s-mirrors.svg?branch=master)

### 原理

利用境外Travis CI服务器协助我们拉取gcr.io的镜像,打上tag并推送至阿里云,实现容器镜像的境内mirrors

#### 目前同步的k8s版本:V1.11.0 V1.12.5 v1.13.3
- 2018.8.15 已同步 dashboard 镜像
- 2018.9.1 已同步 ingress-nginx 镜像

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
- 如果你的机器不能翻越GFW,请看以下步骤：
### 如何使用 
- 运行容器拉取指定镜像
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
选择需要的集群网络方案:`flannel`或`calico`(2选1)
1. flannel:

运行容器实现镜像拉取（可以GFW请忽略本步骤）：
```shell
#获取镜像列表
curl -s  https://raw.githubusercontent.com/coreos/flannel/a70459be0084506e4ec919aa1c114638878db11b/Documentation/kube-flannel.yml | grep image | awk -F': ' '{ print $2  }' > $pwd/image-flannel.txt
#拉取镜像
docker run --rm -it \
        -v $pwd/image-flannel.txt:/image-pull/image.txt \
        -v /var/run/docker.sock:/var/run/docker.sock  \
        registry.cn-hangzhou.aliyuncs.com/geekcloud/image-pull:latest
# 部署flannel 
./install-networks/install-flannel.sh
```
2. calico:
```shell
# 部署calico
./install-networks/install-calico.sh
```

本项目致力于搭建完整的 K8S 平台，如果需要其他额外镜像，您可以使用[image-pull镜像](https://github.com/Mr-Linus/image-pull)实现镜像拉取。
假设需要拉取的镜像名写在文件`/root/image.txt`中: 
```text
quay.io/coreos/flannel:v0.11.0
quay.io/coreos/flannel:v0.12.0
```
运行容器实现镜像拉取：
```
docker run --rm -it \
        -v /root/image.txt:/image-pull/image.txt \
        -v /var/run/docker.sock:/var/run/docker.sock  \
        registry.cn-hangzhou.aliyuncs.com/geekcloud/image-pull:latest
```

### 有任何问题欢迎issue!

![img-source-from-https://github.com/docker/dockercraft](https://github.com/docker/dockercraft/raw/master/docs/img/contribute.png?raw=true)