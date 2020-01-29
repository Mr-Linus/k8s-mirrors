echo "Pulling K8S Images"
version=$(kubeadm config images list | head -1 | awk -F: '{ print $2 }')
sudo docker run --rm -it \
        -v /var/run/docker.sock:/var/run/docker.sock  \
        registry.cn-hangzhou.aliyuncs.com/geekcloud/image-pull:k8s-$version

