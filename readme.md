## K8S-Mirrors

通过Travis CI自动触发拉取官方k8s镜像并推送到用户镜像仓库

![build](https://travis-ci.org/Mr-Linus/k8s-mirrors.svg?branch=master)

目前同步的k8s版本:V1.11.0

本仓库拉取只需修改镜像仓库地址由`k8s.gcr.io`修改为`registry.cn-hangzhou.aliyuncs.com/geekcloud`
你也可以使用本项目中的GCR脚本,修改最后几行:
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

有任何问题欢迎issue!