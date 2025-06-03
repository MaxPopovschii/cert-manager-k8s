#!/bin/bash
# check-certs.sh

# Find certificates expiring in less than 30 days
EXPIRING_CERTS=$(sudo kubeadm certs check-expiration | grep -B 1 "[0-9][0-9]d" | grep -v "RESIDUAL TIME" | awk '{print $1}')

if [ -n "$EXPIRING_CERTS" ]; then
  echo "Certificates to renew found: $EXPIRING_CERTS"
  
  # Renew each certificate
  for CERT in $EXPIRING_CERTS; do
    echo "Renewing $CERT certificate..."
    sudo kubeadm certs renew $CERT
  done
  
  # Back up existing kubeconfig files
  sudo mkdir -p /etc/kubernetes/backup-$(date +%Y%m%d)
  sudo cp /etc/kubernetes/*.conf /etc/kubernetes/backup-$(date +%Y%m%d)/
  
  # Move or delete old files
  sudo mv /etc/kubernetes/admin.conf /etc/kubernetes/admin.conf.old
  sudo mv /etc/kubernetes/controller-manager.conf /etc/kubernetes/controller-manager.conf.old
  sudo mv /etc/kubernetes/scheduler.conf /etc/kubernetes/scheduler.conf.old
  sudo mv /etc/kubernetes/kubelet.conf /etc/kubernetes/kubelet.conf.old
  
  # Update kubeconfig files
  sudo kubeadm init phase kubeconfig admin
  sudo kubeadm init phase kubeconfig controller-manager
  sudo kubeadm init phase kubeconfig scheduler
  sudo kubeadm init phase kubeconfig kubelet
  
  # Update kubeconfig for the user
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  
  # Restart kubelet
  sudo systemctl restart kubelet
  
  echo "Certificate renewal completed."
else
  echo "No certificates need renewal."
fi