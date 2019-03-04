#!/bin/bash
yum update -y && yum install -y curl
echo "Install Docker:"
mkdir -p /etc/docker
touch /etc/docker/daemon.json
cat > /etc/docker/daemon.json <<EOF
{
  	"registry-mirrors": ["https://registry.docker-cn.com"]
}
EOF
yum remove docker docker-common docker-selinux  docker-engine
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo  https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum clean all && yum repolist
yum makecache fast
yum install docker-ce
systemctl enable docker
systemctl daemon-reload 
systemctl restart docker 
echo "Close Swap:"
sed  -i '/\s\+swap\s\+/d' /etc/fstab  &>/dev/null
swapoff -a &>/dev/null
echo "Close selinux:"
setenforce 0 
cat > /etc/selinux/config << EOF 
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected. 
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
EOF
echo "Close Firewalld"
systemctl mask iptables
systemctl mask ip6tables
systemctl mask firewalld
systemctl disable firewalld
systemctl stop firewalld
echo "Install kubeadm:"
curl  https://raw.githubusercontent.com/Mr-Linus/k8s-mirrors/master/install-generic/install-kubeadm_el7.sh | bash - 
echo "Install K8S:"
curl  https://raw.githubusercontent.com/Mr-Linus/k8s-mirrors/master/install-generic/install-k8s-master.sh | bash - 
echo "Install flannel for k8s CNI:"
curl  https://raw.githubusercontent.com/Mr-Linus/k8s-mirrors/master/install-networks/install-flannel.sh | bash - 
echo "Please run the following command for each working node:"
echo "sysctl net.bridge.bridge-nf-call-iptables=1"