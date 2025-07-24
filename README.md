# ✍️ Kubernetes Custom CA & Certificate Management Guide

Questa guida documenta tutti i passaggi per generare una CA personalizzata, firmare i certificati principali del cluster Kubernetes e quelli degli utenti, e aggiornare la configurazione (`kubeconfig`) per l’accesso sicuro.

---

## 📌 1. Creare la CA (Certificate Authority)

```bash
# Genera la chiave privata della CA
openssl genrsa -out ca.key 4096

# Genera il certificato autofirmato valido 50 anni
openssl req -x509 -new -nodes -key ca.key -sha256 -days 18250 -out ca.crt \
  -subj "/CN=kubernetes-ca"
```

---

## 📌 2. Configurazione SAN per l’API Server

Crea un file `apiserver-ext.cnf`:

```ini
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
```

---

## 📌 3. Generare chiave + CSR + firmare certificato per API Server

```bash
openssl genrsa -out apiserver.key 2048

openssl req -new -key apiserver.key -out apiserver.csr -config apiserver-ext.cnf

openssl x509 -req -in apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out apiserver.crt -days 36500 -extensions req_ext -extfile apiserver-ext.cnf
```

---

## 📌 4. Certificati Client: Admin, QA, External Developer

### 🔹 Admin (15 anni)

```bash
openssl genrsa -out admin.key 2048
openssl req -new -key admin.key -out admin.csr -subj "/CN=admin"
openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out admin.crt -days 5475 -extfile <(printf "extendedKeyUsage=clientAuth")
```

### 🔹 QA Developer (15 anni)

```bash
openssl genrsa -out qa-developer.key 2048
openssl req -new -key qa-developer.key -out qa-developer.csr -subj "/CN=qa-developer"
openssl x509 -req -in qa-developer.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out qa-developer.crt -days 5475 -extfile <(printf "extendedKeyUsage=clientAuth")
```

### 🔹 External Developer (2 anni)

```bash
openssl genrsa -out external-developer.key 2048
openssl req -new -key external-developer.key -out external-developer.csr -subj "/CN=external-developer"
openssl x509 -req -in external-developer.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out external-developer.crt -days 730 -extfile <(printf "extendedKeyUsage=clientAuth")
```

---

## 📌 5. Sostituire i certificati nel cluster

```bash
cp apiserver.crt /etc/kubernetes/pki/apiserver.crt
cp apiserver.key /etc/kubernetes/pki/apiserver.key
```

---

## 📌 6. Riavviare il controllo del cluster

```bash
systemctl restart kubelet
```

---

## 📌 7. Generare kubeconfig per utenti

### 🔹 Esempio: Admin

```bash
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
```

---

## ✅ Test

```bash
KUBECONFIG=admin.kubeconfig kubectl get nodes
```

---

## 📂 File generati

| File                     | Descrizione                          |
|--------------------------|--------------------------------------|
| `ca.crt`, `ca.key`       | Root Certificate Authority           |
| `apiserver.crt`, `.key`  | Certificato server firmato dalla CA  |
| `admin.crt`, `.key`      | Certificato client Admin             |
| `qa-developer.crt`       | Certificato client QA                |
| `external-developer.crt` | Certificato client External          |
| `*.kubeconfig`           | Configurazioni client                |

---

## 📎 Note

- Puoi modificare il campo `CN` nei certificati client per rappresentare gruppi o utenti.
- I certificati devono essere copiati correttamente nel path `/etc/kubernetes/pki/` per essere utilizzati.
- I file `kubeconfig` generati possono essere usati anche su macchine remote per autenticarsi al cluster.

---
