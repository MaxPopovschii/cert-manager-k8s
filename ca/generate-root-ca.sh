#!/bin/bash
# ca/generate-root-ca.sh

mkdir -p ca
openssl req -x509 -new -key ca.key -out ca.crt -days 18250 -subj "/CN=kubernetes-ca"

