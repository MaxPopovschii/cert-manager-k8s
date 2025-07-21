#!/bin/bash
# kubeconfigs/create-kubeconfig.sh

USER=$1
CLUSTER_NAME=$2  #kubectl config view -o jsonpath='{.clusters[0].name}'
SERVER_URL=$3    #kubectl config view -o jsonpath='{.clusters[0].cluster.server}'


mkdir -p users/$USER

kubectl config set-cluster $CLUSTER_NAME \
  --certificate-authority=ca/root-ca.crt \
  --embed-certs=true \
  --server=$SERVER_URL \
  --kubeconfig=users/$USER/kubeconfig

kubectl config set-credentials $USER \
  --client-certificate=users/$USER/$USER.crt \
  --client-key=users/$USER/$USER.key \
  --embed-certs=true \
  --kubeconfig=users/$USER/kubeconfig

kubectl config set-context $USER-context \
  --cluster=$CLUSTER_NAME \
  --user=$USER \
  --kubeconfig=users/$USER/kubeconfig

kubectl config use-context $USER-context --kubeconfig=users/$USER/kubeconfig
