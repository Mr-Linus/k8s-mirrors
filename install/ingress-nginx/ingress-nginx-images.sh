#!/bin/bash

controller_version=0.19.0
defaultbackend_version=1.4
registry_name=registry.cn-hangzhou.aliyuncs.com/geekcloud
registry_host=registry.cn-hangzhou.aliyuncs.com

function pull_images(){
    echo "Pulling Images"
    sudo docker pull gcr.io/google_containers/defaultbackend:$defaultbackend_version
    sudo docker pull quay.io/kubernetes-ingress-controller/nginx-ingress-controller:$controller_version
}

function set_tags(){
    echo "Setting Tags"
    sudo docker tag gcr.io/google_containers/defaultbackend:$defaultbackend_version $registry_name/defaultbackend:$defaultbackend_version
    sudo docker tag quay.io/kubernetes-ingress-controller/nginx-ingress-controller:$controller_version $registry_name/nginx-ingress-controller:$controller_version
}

function push_images(){
    echo "Pushing Images"
    sudo docker login -u $username -p $password registry.cn-hangzhou.aliyuncs.com
    python check-tags.py -i $accessid -k $accesskey -n defaultbackend -t $defaultbackend_version -s geekcloud \
    && sudo docker push $registry_name/defaultbackend:$defaultbackend_version
    python check-tags.py -i $accessid -k $accesskey -n nginx-ingress-controller -t $controller_version -s geekcloud \
    && sudo docker push $registry_name/nginx-ingress-controller:$controller_version
    sudo docker logout 
}

function reset_tags(){
    sudo docker tag $registry_name/defaultbackend:$defaultbackend_version gcr.io/google_containers/defaultbackend:$defaultbackend_version
    sudo docker tag $registry_name/nginx-ingress-controller:$controller_version quay.io/kubernetes-ingress-controller/nginx-ingress-controller:$controller_version
}
function local_pull_images(){
    sudo docker pull $registry_name/defaultbackend:$defaultbackend_version 
    sudo docker pull $registry_name/nginx-ingress-controller:$controller_version

}

#server
pull_images
set_tags
push_images

#local

#local_pull_images
#reset_tags