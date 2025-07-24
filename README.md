# Kubernetes Certificate Management System

> A comprehensive solution for managing certificates in Kubernetes clusters using cert-manager

## 🎯 Overview

This project implements a complete PKI infrastructure for Kubernetes environments, featuring:
- 50-year Root CA for long-term trust anchoring
- Role-based certificate distribution
- Environment-agnostic certificate management

## 📋 Features

| User Type | Certificate Validity | Use Case |
|-----------|---------------------|----------|
| Root CA | 50 years | Trust anchor for all certificates |
| Admin | 15 years | Cluster administration |
| QA Developer | 15 years | Internal development & testing |
| External Developer | 2 years | Temporary access |


## 🚀 Quick Start

### Prerequisites
- Kubernetes cluster (v1.19+)
- kubectl CLI tool

1. Generare CA

# Genera la chiave privata della CA (4096 bit)
openssl genrsa -out ca.key 4096

# Genera il certificato root autofirmato della CA valido 50 anni (18250 giorni)
openssl req -x509 -new -nodes -key ca.key -sha256 -days 18250 -out ca.crt \
  -subj "/CN=kubernetes-ca"

2. Creare configurazione OpenSSL per certificato API server con SAN (Subject Alternative Names)

Crea un file chiamato apiserver-ext.cnf con questo contenuto (modifica IP e DNS se serve):

[ req ]
default_bits       = 2048
prompt             = no
default_md         = sha256
req_extensions     = req_ext
distinguished_name = dn

[ dn ]
CN = kubernetes

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
DNS.5 = controlplane
IP.1  = 127.0.0.1
IP.2  = <IP_PRIVATO_DEL_MASTER>

3. Generare chiave e CSR per API server
openssl genrsa -out apiserver.key 2048

openssl req -new -key apiserver.key -out apiserver.csr -config apiserver-ext.cnf

4. Firmare il certificato API server con la CA
openssl x509 -req -in apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out apiserver.crt -days 36500 -extensions req_ext -extfile apiserver-ext.cnf

5. Generare e firmare certificati client e di sistema
Esempio per admin (durata 15 anni):

openssl genrsa -out admin.key 2048

openssl req -new -key admin.key -out admin.csr -subj "/CN=admin"

openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out admin.crt -days 5475 -extfile <(printf "extendedKeyUsage=clientAuth")
  
Per qa-developer (15 anni):
openssl genrsa -out qa-developer.key 2048

openssl req -new -key qa-developer.key -out qa-developer.csr -subj "/CN=qa-developer"

openssl x509 -req -in qa-developer.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out qa-developer.crt -days 5475 -extfile <(printf "extendedKeyUsage=clientAuth")

Per external-developer (2 anni):

openssl genrsa -out external-developer.key 2048

openssl req -new -key external-developer.key -out external-developer.csr -subj "/CN=external-developer"

openssl x509 -req -in external-developer.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out external-developer.crt -days 730 -extfile <(printf "extendedKeyUsage=clientAuth")

6. Rigenerare i kubeconfig client


Esempio per admin:

kubectl config set-cluster kubernetes \
  --certificate-authority=ca.crt \
  --server=https://controlplane:6443 \
  --kubeconfig=admin.kubeconfig \
  --embed-certs=true

kubectl config set-credentials admin \
  --client-certificate=admin.crt \
  --client-key=admin.key \
  --kubeconfig=admin.kubeconfig \
  --embed-certs=true

kubectl config set-context admin@kubernetes \
  --cluster=kubernetes \
  --user=admin \
  --kubeconfig=admin.kubeconfig

kubectl config use-context admin@kubernetes --kubeconfig=admin.kubeconfig
