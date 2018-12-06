#!/usr/bin/env bash
set -exuo pipefail
IFS=$'\n\t'

USER=kubeadm_demo
for host in ${secondary_masters}; do
    sudo -E scp /etc/kubernetes/pki/ca.crt $${USER}@$${host}:
    sudo -E scp /etc/kubernetes/pki/ca.key $${USER}@$${host}:
    sudo -E scp /etc/kubernetes/pki/sa.key $${USER}@$${host}:
    sudo -E scp /etc/kubernetes/pki/sa.pub $${USER}@$${host}:
    sudo -E scp /etc/kubernetes/pki/front-proxy-ca.crt $${USER}@$${host}:
    sudo -E scp /etc/kubernetes/pki/front-proxy-ca.key $${USER}@$${host}:
    sudo -E scp /etc/kubernetes/pki/etcd/ca.crt $${USER}@$${host}:etcd-ca.crt
    sudo -E scp /etc/kubernetes/pki/etcd/ca.key $${USER}@$${host}:etcd-ca.key
    sudo -E scp /etc/kubernetes/admin.conf $${USER}@$${host}:

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