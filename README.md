# kubeadm-demo

## Apply terraform config
```bash
terraform apply
```

## Primary master
```bash
ssh kubeadm_demo@$(terraform output primary_master)

sudo kubeadm init --config=kubeadm-config.yml

# Save join command <- HERE

# Copy generated kube config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Apply weave network plugin
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# Wait pods to start
kubectl get pod -n kube-system -w

chmod +x copy_certs.sh && ./copy_certs.sh
```

## On every secondary master
```bash
terraform output secondary_masters

ssh kubeadm_demo@secondary "JOIN_COMMAND --experimental-control-plane"
ssh kubeadm_demo@secondary "kubectl get pod -n kube-system -w"
```

## On every secondary node
```bash
terraform output nodes

ssh kubeadm_demo@node "JOIN_COMMAND"
```
