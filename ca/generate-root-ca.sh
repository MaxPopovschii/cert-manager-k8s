#!/bin/bash
# ca/generate-root-ca.sh

mkdir -p ca
openssl genrsa -out ca/root-ca.key 4096
openssl req -x509 -new -nodes -key ca/root-ca.key -sha256 -days 18250 \
    -out ca/root-ca.crt -subj "/CN=Kubernetes Root CA"
