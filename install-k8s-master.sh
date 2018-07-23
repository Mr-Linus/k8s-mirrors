# install k8s
kubeadm init --kubernetes-version=v1.11.0  --pod-network-cidr=10.16.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
