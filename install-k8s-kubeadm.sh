#!/bin/bash
yum update && yum install -y curl
echo "Add aliyum Repo:"
curl -s https://raw.githubusercontent.com/Mr-Linus/shell-repo/master/yum/yum.sh | bash - 
echo "Install Docker:"
curl -s https://raw.githubusercontent.com/Mr-Linus/shell-repo/master/docker/docker_el.sh | bash - 
echo "Close Swap:"
sed  -i '/\s\+swap\s\+/d' /etc/fstab  &>/dev/null
swapoff -a &>/dev/null
echo "Close selinux:"
setenforce 0 
cat > /etc/selinx/config << EOF 
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
curl -s https://raw.githubusercontent.com/Mr-Linus/k8s-mirrors/master/install-generic/install-kubeadm_el7.sh | bash - 
echo "Install K8S:"
curl -s https://raw.githubusercontent.com/Mr-Linus/k8s-mirrors/master/install-generic/install-k8s-master.sh | bash - 
echo "Install flannel for k8s CNI:"
curl -s https://raw.githubusercontent.com/Mr-Linus/k8s-mirrors/master/install-networks/install-flannel.sh | bash - 
echo "Please run the following command for each working node:"
echo "sysctl net.bridge.bridge-nf-call-iptables=1"