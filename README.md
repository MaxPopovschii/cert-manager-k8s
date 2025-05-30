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

## 🏗️ Project Structure

```
cert-manager-k8s/
├── src/
│   ├── ca/                      # Certificate Authority configs
│   │   ├── root-ca.yaml         # Root CA (50 years)
│   │   └── intermediate-ca.yaml # Intermediate CA
│   │
│   ├── certificates/            # User certificates
│   │   ├── admin-cert.yaml      # Admin (15 years)
│   │   ├── qa-dev-cert.yaml     # QA Dev (15 years)
│   │   └── ext-dev-cert.yaml    # External Dev (2 years)
│   │
│   ├── roles/                   # RBAC configurations
│   │   ├── admin-role.yaml
│   │   ├── qa-dev-role.yaml
│   │   └── ext-dev-role.yaml
│   │
│   └── bindings/               # Role bindings
│       ├── admin-binding.yaml
│       ├── qa-dev-binding.yaml
│       └── ext-dev-binding.yaml
│
├── scripts/
│   ├── create-ca.sh           # CA setup script
│   └── create-certs.sh        # Certificate generation script
│
└── README.md
```

## 🚀 Quick Start

### Prerequisites
- Kubernetes cluster (v1.19+)
- kubectl CLI tool
- Helm (optional)

### Installation

1. **Install cert-manager**
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml
```

2. **Deploy Root CA**
```bash
./scripts/create-ca.sh
```

3. **Create User Certificates**
```bash
./scripts/create-certs.sh
```

4. **Apply RBAC Configurations**
```bash
kubectl apply -f src/roles/
kubectl apply -f src/bindings/
```

## 🔍 Verification

Check certificate status:
```bash
kubectl get certificates -n cert-manager
kubectl get clusterissuers
```

Verify certificate chain:
```bash
kubectl describe certificate admin-cert -n cert-manager
```

## ⚠️ Security Considerations

- Store Root CA private key securely
- Implement regular certificate rotation for external developers
- Monitor certificate expiration dates
- Keep cert-manager updated

## 🔄 Certificate Renewal

Certificates are automatically renewed by cert-manager when they reach 2/3 of their lifetime. Manual renewal:
```bash
kubectl delete secret <cert-secret-name> -n cert-manager
```

## 📚 Documentation

- [cert-manager Official Docs](https://cert-manager.io/docs/)
- [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.