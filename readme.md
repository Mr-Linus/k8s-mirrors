## K8S-Mirrors

通过Travis CI自动触发拉取官方k8s镜像并推送到阿里云容器镜像仓库

![build](https://travis-ci.org/Mr-Linus/k8s-mirrors.svg?branch=master)

### 原理

利用境外Travis CI服务器协助我们拉取gcr.io的镜像,打上tag并推送至阿里云,实现容器镜像的境内mirrors
本项目致力于搭建完整的 K8S 平台，如果需要其他额外镜像，您可以使用[image-pull 镜像工具](https://github.com/Mr-Linus/image-pull)实现镜像拉取。
#### 目前同步的k8s版本:V1.12.5 - V1.17.x（最新）
- 2019.9.24 支持自动更新镜像
- 2018.8.15 已同步 dashboard 镜像
- 2018.9.1 已同步 ingress-nginx 镜像


### 国内拉取 gcr.io 镜像
- 如果你的机器可以翻越GFW,请忽略本步骤，如果你的机器不能翻越GFW,请遵循如下流程：
### 如何使用 

- 方法1：设置 kubeadm 拉取仓库

> 创建文件：image.yaml

```yaml
apiVersion: kubeadm.k8s.io/v1alpha3
kind: ClusterConfiguration
imageRepository: registry.cn-hangzhou.aliyuncs.com/image-mirror
```

拉取镜像（每个节点）：

```shell
kubeadm config images pull --config image.yaml
```

- 方法2：运行容器拉取指定镜像
 

> - 以版本V1.17.2为例
```shell
docker run --rm -it \
        -v /var/run/docker.sock:/var/run/docker.sock  \
        registry.cn-hangzhou.aliyuncs.com/geekcloud/image-pull:k8s-v1.17.2
```

- 方法3：执行命令：
```shell
images=($(kubeadm config images list 2>/dev/null | awk -F'/' '{print $2}'))
for imageName in ${images[@]} ; do
    echo "docker pull registry.cn-hangzhou.aliyuncs.com/image-mirror/${imageName}"
    docker pull registry.cn-hangzhou.aliyuncs.com/image-mirror/${imageName}
    echo "docker tag registry.cn-hangzhou.aliyuncs.com/image-mirror/${imageName} k8s.gcr.io/${imageName}"
    docker tag registry.cn-hangzhou.aliyuncs.com/image-mirror/${imageName} k8s.gcr.io/${imageName}
    echo "docker tag registry.cn-hangzhou.aliyuncs.com/image-mirror/${imageName} k8s.gcr.io/${imageName}"
    docker rmi registry.cn-hangzhou.aliyuncs.com/image-mirror/${imageName}
done
```

#### 需要注意的是,每个节点无论是工作节点还是master节点都需要拉取镜像!! 
#### 否则将会出现pod一直处于pending或者构建镜像的状态!! 

### 下面可以做什么:

- 拉取 CNI 镜像
可选的集群网络方案:`flannel`或`calico`，这里以flannel为例:

运行容器实现镜像拉取（可以GFW请忽略本步骤）：
```shell
#获取镜像列表
curl -s  https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml | grep image | awk -F': ' '{ print $2  }' > $pwd/image-flannel.txt
#拉取镜像
docker run --rm -it \
        -v $pwd/image-flannel.txt:/image-pull/image.txt \
        -v /var/run/docker.sock:/var/run/docker.sock  \
        registry.cn-hangzhou.aliyuncs.com/geekcloud/image-pull:latest
```

### 关于拉取 quay.io 镜像
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