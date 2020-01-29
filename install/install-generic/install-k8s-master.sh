#!/bin/bash
echo "add images"
cat > $(pwd)/kubeadm-images.yaml << EOF	# add images
apiVersion: kubeadm.k8s.io/v1alpha3	docker run --rm -it \
kind: ClusterConfiguration	        -v /var/run/docker.sock:/var/run/docker.sock  \
imageRepository: registry.cn-hangzhou.aliyuncs.com/image-mirror	
EOF
kubeadm config images pull --config $(pwd)/kubeadm-images.yaml
## init k8s 
kubeadm init --kubernetes-version=$version  --pod-network-cidr=10.244.0.0/16 
## --kubernetes-version=v1.13.4 指定版本
## 如果你使用calico或者flannel网络,必须加上参数--pod-network-cidr=10.244.0.0/16
## 构建 k8s 配置文件夹并拷贝管理员默认配置文件
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf
