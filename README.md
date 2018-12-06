# kubeadm-demo

## Change google project_id

```hcl-terraform
# terrafotm.tfvars
project_id = "your_project_id"
```

## Apply terraform config
```bash
terraform apply
```

## Primary master
```bash
ssh -A kubeadm_demo@$(terraform output primary_master)

sudo kubeadm init --config=kubeadm-config.yml

# Save join command

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

## Join masters
```bash
export JOIN_COMMAND="<PASTE_HERE>"

terraform output secondary_masters

# After every join you should manually set "masters_enabled" var in terraform.tfvars to number of currently running masters
ssh kubeadm_demo@secondary "sudo ${JOIN_COMMAND} --experimental-control-plane"
ssh kubeadm_demo@secondary "kubectl get pod -n kube-system -w"
```

## On every secondary node
```bash
terraform output nodes

ssh kubeadm_demo@node_ip "sudo ${JOIN_COMMAND}"
```
