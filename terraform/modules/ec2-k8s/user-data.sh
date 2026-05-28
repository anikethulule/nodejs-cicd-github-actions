#!/bin/bash

set -e

exec > /var/log/k8s-user-data.log 2>&1

echo "=================================================="
echo "Starting Kubernetes single-node installation"
echo "=================================================="

apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl gpg software-properties-common

echo "Disabling swap..."
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "Loading kernel modules..."
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

echo "Applying sysctl settings..."
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

echo "Installing containerd..."
apt-get install -y containerd

mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml > /dev/null

sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

systemctl restart containerd
systemctl enable containerd

echo "Installing Kubernetes packages from pkgs.k8s.io..."
mkdir -p /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/${kubernetes_version}/deb/Release.key | \
  gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${kubernetes_version}/deb/ /" | \
  tee /etc/apt/sources.list.d/kubernetes.list

apt-get update -y
apt-get install -y kubelet kubeadm kubectl conntrack

apt-mark hold kubelet kubeadm kubectl

echo "Initializing Kubernetes cluster..."
kubeadm init \
  --pod-network-cidr=192.168.0.0/16 \
  --ignore-preflight-errors=NumCPU

echo "Configuring kubectl for ubuntu user..."
mkdir -p /home/ubuntu/.kube
cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/config

echo "Configuring kubectl for root user..."
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config

echo "Installing Calico CNI..."
su - ubuntu -c "kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/${calico_version}/manifests/calico.yaml"

echo "Allow scheduling workload pods on single control-plane node..."
su - ubuntu -c "kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true"

echo "Waiting for Kubernetes components..."
sleep 120

su - ubuntu -c "kubectl get nodes"
su - ubuntu -c "kubectl get pods -A"

echo "=================================================="
echo "Kubernetes installation completed successfully"
echo "Application NodePort will be: ${nodeport}"
echo "=================================================="