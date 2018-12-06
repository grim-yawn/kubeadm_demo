#!/usr/bin/env bash
set -exuo pipefail
IFS=$'\n\t'

# Disable swap
swapoff -a


# Update cache and install deps
apt-get update

apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update

apt-get -y install docker-ce
apt-mark hold docker-ce

# Install kubelet and kubeadm
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update

apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
