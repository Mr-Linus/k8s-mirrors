#!/bin/bash
# install k8s

## init k8s 
kubeadm init --kubernetes-version=v1.11.0  --pod-network-cidr=10.16.0.0/16
## --kubernetes-version=v1.11.0 指定版本
## 如果你使用calico或者flannel网络,必须加上参数--pod-network-cidr=10.16.0.0/16

## 构建 k8s 配置文件夹并拷贝管理员默认配置文件
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
