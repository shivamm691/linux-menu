#######################
# === Master Only === #
#######################
# Initialize the Kubernetes master using the public IP address of the master as the apiserver-advertise-address. Set the pod-network-cidr to the cidr address used in the network overlay (flannel, weave, etc...) configuration.
curl -s https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml | grep -E '"Network": "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}"' | cut -d'"' -f4
sudo kubeadm init --apiserver-advertise-address=${master_ip_address} --pod-network-cidr=${NETWORK_OVERLAY_CIDR_NET}

# Copy the cluster configuration to the regular users home directory
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Deploy the Flannel Network Overlay
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# check the readiness of nodes
kubectl get nodes

# check that coredns, apiserver, etcd, and flannel pods are running
kubectl get pods --all-namespaces

# List k8s bootstrap tokens
sudo kubeadm token list

# Generate a new k8s bootstrap token !ONLY! if all other tokens have expired
sudo kubeadm token create

# Decode the Discovery Token CA Cert Hash
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'


