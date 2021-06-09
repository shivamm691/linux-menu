
########################
# === Workers Only === #
########################
# Join worker node to k8s cluster using the token and discovery-token-ca-cert-hash from master
sudo kubeadm join ${MASTER_HOSTNAME}:6443 --token ${TOKEN} --discovery-token-ca-cert-hash sha256:${DISCOVERY_TOKEN_CA_CERT_HASH}
