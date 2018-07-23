#!/bin/bash

k8s_version=v1.11.0
pause_version=3.1
etcd_version=3.2.18
coredns_version=1.1.3
registry_name=registry.cn-hangzhou.aliyuncs.com/geekcloud
registry_host=registry.cn-hangzhou.aliyuncs.com

function pull_images(){
    echo "Pulling Images"
    docker pull k8s.gcr.io/kube-apiserver-amd64:$k8s_version
    docker pull k8s.gcr.io/kube-controller-manager-amd64:$k8s_version
    docker pull k8s.gcr.io/kube-scheduler-amd64:$k8s_version
    docker pull k8s.gcr.io/kube-proxy-amd64:$k8s_version
    docker pull k8s.gcr.io/pause:$pause_version
    docker pull k8s.gcr.io/etcd-amd64:$etcd_version
    docker pull k8s.gcr.io/coredns:$coredns_version
}

function set_tags(){
    echo "Setting Tags"
    docker tag k8s.gcr.io/kube-apiserver-amd64:$k8s_version $registry_name/kube-apiserver-amd64:$k8s_version
    docker tag k8s.gcr.io/kube-controller-manager-amd64:$k8s_version $registry_name/kube-controller-manager-amd64:$k8s_version
    docker tag k8s.gcr.io/kube-scheduler-amd64:$k8s_version $registry_name/kube-scheduler-amd64:$k8s_version
    docker tag k8s.gcr.io/kube-proxy-amd64:$k8s_version $registry_name/kube-proxy-amd64:$k8s_version
    docker tag k8s.gcr.io/pause:$pause_version $registry_name/pause:$pause_version
    docker tag k8s.gcr.io/etcd-amd64:$etcd_version $registry_name/etcd-amd64:$etcd_version
    docker tag k8s.gcr.io/coredns:$coredns_version $registry_name/coredns:$coredns_version
}

function push_images(){
    echo "Pushing Images"
    docker login -u $username -p $password registry.cn-hangzhou.aliyuncs.com
    sudo docker push $registry_name/kube-apiserver-amd64:$k8s_version
    sudo docker push $registry_name/kube-controller-manager-amd64:$k8s_version
    sudo docker push $registry_name/kube-scheduler-amd64:$k8s_version
    sudo docker push $registry_name/kube-proxy-amd64:$k8s_version
    sudo docker push $registry_name/pause:$pause_version
    sudo docker push $registry_name/etcd-amd64:$etcd_version
    sudo docker push $registry_name/coredns:$coredns_version
}

pull_images
set_tags
push_images