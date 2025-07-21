#!/bin/bash
# users/generate-user-cert.sh

USER=$1
DAYS=$2

mkdir -p users/$USER
openssl genrsa -out users/$USER/$USER.key 4096
openssl req -new -key users/$USER/$USER.key -out users/$USER/$USER.csr \
  -subj "/CN=$USER/O=k8s-users"
openssl x509 -req -in users/$USER/$USER.csr -CA ca/root-ca.crt -CAkey ca/root-ca.key \
  -CAcreateserial -out users/$USER/$USER.crt -days $DAYS -sha256
