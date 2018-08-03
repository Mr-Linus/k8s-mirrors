#!/bin/bash

k8s_version=v1.11.0
pause_version=3.1
etcd_version=3.2.18
coredns_version=1.1.3
registry_name=registry.cn-hangzhou.aliyuncs.com/geekcloud
registry_host=registry.cn-hangzhou.aliyuncs.com

function pull_images(){
    echo "Pulling Images"
    sudo docker pull k8s.gcr.io/kube-apiserver-amd64:$k8s_version
    sudo docker pull k8s.gcr.io/kube-controller-manager-amd64:$k8s_version
    sudo docker pull k8s.gcr.io/kube-scheduler-amd64:$k8s_version
    sudo docker pull k8s.gcr.io/kube-proxy-amd64:$k8s_version
    sudo docker pull k8s.gcr.io/pause:$pause_version
    sudo docker pull k8s.gcr.io/etcd-amd64:$etcd_version
    sudo docker pull k8s.gcr.io/coredns:$coredns_version
}

function set_tags(){
    echo "Setting Tags"
    sudo docker tag k8s.gcr.io/kube-apiserver-amd64:$k8s_version $registry_name/kube-apiserver-amd64:$k8s_version
    sudo docker tag k8s.gcr.io/kube-controller-manager-amd64:$k8s_version $registry_name/kube-controller-manager-amd64:$k8s_version
    sudo docker tag k8s.gcr.io/kube-scheduler-amd64:$k8s_version $registry_name/kube-scheduler-amd64:$k8s_version
    sudo docker tag k8s.gcr.io/kube-proxy-amd64:$k8s_version $registry_name/kube-proxy-amd64:$k8s_version
    sudo docker tag k8s.gcr.io/pause:$pause_version $registry_name/pause:$pause_version
    sudo docker tag k8s.gcr.io/etcd-amd64:$etcd_version $registry_name/etcd-amd64:$etcd_version
    sudo docker tag k8s.gcr.io/coredns:$coredns_version $registry_name/coredns:$coredns_version
}

function push_images(){
    echo "Pushing Images"
    sudo docker login -u $username -p $password registry.cn-hangzhou.aliyuncs.com
    python check-tags.py -i $accessid -k $accesskey -n kube-apiserver-amd64 -t $k8s_version -s geekcloud \
    && sudo docker push $registry_name/kube-apiserver-amd64:$k8s_version 
    python check-tags.py -i $accessid -k $accesskey -n kube-controller-manager-amd64 -t $k8s_version -s geekcloud \
    && sudo docker push $registry_name/kube-controller-manager-amd64:$k8s_version 
    python check-tags.py -i $accessid -k $accesskey -n kube-scheduler-amd64 -t $k8s_version -s geekcloud \
    && sudo docker push $registry_name/kube-scheduler-amd64:$k8s_version
    python check-tags.py -i $accessid -k $accesskey -n kube-proxy-amd64 -t $k8s_version -s geekcloud \
    && sudo docker push $registry_name/kube-proxy-amd64:$k8s_version
    python check-tags.py -i $accessid -k $accesskey -n pause -t $pause_version -s geekcloud \
    && sudo docker push $registry_name/pause:$pause_version
    python check-tags.py -i $accessid -k $accesskey -n etcd-amd64 -t $etcd_version -s geekcloud \
    && sudo docker push $registry_name/etcd-amd64:$etcd_version
    python check-tags.py -i $accessid -k $accesskey -n coredns -t $coredns_version -s geekcloud \
    && sudo docker push $registry_name/coredns:$coredns_version
    sudo docker logout 
}

function reset_tags(){
    sudo docker tag $registry_name/kube-apiserver-amd64:$k8s_version k8s.gcr.io/kube-apiserver-amd64:$k8s_version
    sudo docker tag $registry_name/kube-controller-manager-amd64:$k8s_version k8s.gcr.io/kube-controller-manager-amd64:$k8s_version
    sudo docker tag $registry_name/kube-scheduler-amd64:$k8s_version k8s.gcr.io/kube-scheduler-amd64:$k8s_version 
    sudo docker tag $registry_name/kube-proxy-amd64:$k8s_version k8s.gcr.io/kube-proxy-amd64:$k8s_version 
    sudo docker tag $registry_name/pause:$pause_version k8s.gcr.io/pause:$pause_version 
    sudo docker tag $registry_name/etcd-amd64:$etcd_version k8s.gcr.io/etcd-amd64:$etcd_version 
    sudo docker tag $registry_name/coredns:$coredns_version k8s.gcr.io/coredns:$coredns_version
}

function local_pull_images(){
    sudo docker pull $registry_name/kube-apiserver-amd64:$k8s_version 
    sudo docker pull $registry_name/kube-controller-manager-amd64:$k8s_version 
    sudo docker pull $registry_name/kube-scheduler-amd64:$k8s_version 
    sudo docker pull $registry_name/kube-proxy-amd64:$k8s_version 
    sudo docker pull $registry_name/pause:$pause_version 
    sudo docker pull $registry_name/etcd-amd64:$etcd_version 
    sudo docker pull $registry_name/coredns:$coredns_version 
}

#server

pull_images
set_tags
push_images

#local

#local_pull_images
#reset_tags