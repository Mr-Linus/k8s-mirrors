### 添加阿里云镜像软件源
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
## 更新系统所有软件
yum update -y
## 安装kubeadm
yum install -y kubeadm 
## 设置kubelet开机启动并立即启动
systemctl enable kubelet && systemctl start kubelet
