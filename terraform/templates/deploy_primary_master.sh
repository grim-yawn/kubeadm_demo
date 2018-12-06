#!/usr/bin/env bash
set -exuo pipefail
IFS=$'\n\t'


sudo kubeadm init --config=kubeadm-config.yml

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

kubectl get pod -n kube-system -w

USER=kubeadm_demo
for host in ${secondary_masters}; do
    scp /etc/kubernetes/pki/ca.crt $${USER}@$${host}:
    scp /etc/kubernetes/pki/ca.key $${USER}@$${host}:
    scp /etc/kubernetes/pki/sa.key $${USER}@$${host}:
    scp /etc/kubernetes/pki/sa.pub $${USER}@$${host}:
    scp /etc/kubernetes/pki/front-proxy-ca.crt $${USER}@$${host}:
    scp /etc/kubernetes/pki/front-proxy-ca.key $${USER}@$${host}:
    scp /etc/kubernetes/pki/etcd/ca.crt $${USER}@$${host}:etcd-ca.crt
    scp /etc/kubernetes/pki/etcd/ca.key $${USER}@$${host}:etcd-ca.key
    scp /etc/kubernetes/admin.conf $${USER}@$${host}:

    ssh $${USER}@$${host} sudo mkdir -p /etc/kubernetes/pki/etcd
    ssh $${USER}@$${host} sudo mv /home/$${USER}/ca.crt /etc/kubernetes/pki/
    ssh $${USER}@$${host} sudo mv /home/$${USER}/ca.key /etc/kubernetes/pki/
    ssh $${USER}@$${host} sudo mv /home/$${USER}/sa.pub /etc/kubernetes/pki/
    ssh $${USER}@$${host} sudo mv /home/$${USER}/sa.key /etc/kubernetes/pki/
    ssh $${USER}@$${host} sudo mv /home/$${USER}/front-proxy-ca.crt /etc/kubernetes/pki/
    ssh $${USER}@$${host} sudo mv /home/$${USER}/front-proxy-ca.key /etc/kubernetes/pki/
    ssh $${USER}@$${host} sudo mv /home/$${USER}/etcd-ca.crt /etc/kubernetes/pki/etcd/ca.crt
    ssh $${USER}@$${host} sudo mv /home/$${USER}/etcd-ca.key /etc/kubernetes/pki/etcd/ca.key
    ssh $${USER}@$${host} sudo mv /home/$${USER}/admin.conf /etc/kubernetes/admin.conf
done