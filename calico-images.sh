#!/bin/bash

calico_typha_version=v0.7.4
calico_node_version=v3.1.3
calico_cni_version=v3.1.3
registry_name=registry.cn-hangzhou.aliyuncs.com/geekcloud
registry_host=registry.cn-hangzhou.aliyuncs.com

function pull_images(){
    echo "Pulling Images"
    docker pull quay.io/calico/typha:$calico_typha_version
    docker pull quay.io/calico/node:v3.1.3:$calico_node_version
    docker pull quay.io/calico/cni:v3.1.3:$calico_cni_version

function set_tags(){
    echo "Setting Tags"
    docker tag quay.io/calico/typha:$calico_typha_version $registry_name/typha:$calico_typha_version
    docker tag quay.io/calico/node:$calico_node_version $registry_name/calico-node:$calico_node_version
    docker tag quay.io/calico/cni:$calico_cni_version $registry_name/calico-cni:$calico_cni_version
}

function push_images(){
    echo "Pushing Images"
    docker login -u $username -p $password registry.cn-hangzhou.aliyuncs.com
    sudo docker push $registry_name/typha:$calico_typha_version
    sudo docker push $registry_name/calico-node:$calico_node_version
    sudo docker push $registry_name/calico-cni:$calico_cni_version
    docker logout 
}

function reset_tags(){
    docker tag $registry_name/typha:$calico_typha_version quay.io/calico/typha:$calico_typha_version 
    docker tag $registry_name/calico-node:$calico_node_version quay.io/calico/node:$calico_node_version
    docker tag $registry_name/calico-cni:$calico_cni_version quay.io/calico/cni:$calico_cni_version
}
}

function local_pull_images(){
    sudo docker pull $registry_name/typha:$calico_typha_version
    sudo docker pull $registry_name/calico-node:$calico_node_version
    sudo docker pull $registry_name/calico-cni:$calico_cni_version
}

#server
pull_images
set_tags
push_images

#local

#local_pull_images
#reset_tags