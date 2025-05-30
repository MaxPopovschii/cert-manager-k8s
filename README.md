# cert-manager-k8s Project

This project is designed to create and manage certificates in a Kubernetes environment using cert-manager. It includes the setup for a root Certificate Authority (CA) and specific user certificates with defined validity periods.

## Project Structure

```
cert-manager-k8s
├── src
│   ├── ca
│   │   ├── root-ca.yaml         # Configuration for the root CA (50 years validity)
│   │   └── intermediate-ca.yaml  # Configuration for the intermediate CA
│   ├── certificates
│   │   ├── admin-cert.yaml      # Admin user's certificate (15 years validity)
│   │   ├── qa-dev-cert.yaml     # QA developer's certificate (15 years validity)
│   │   └── ext-dev-cert.yaml     # External developer's certificate (2 years validity)
│   ├── roles
│   │   ├── admin-role.yaml       # Role definition for the admin user
│   │   ├── qa-dev-role.yaml      # Role definition for the QA developer
│   │   └── ext-dev-role.yaml     # Role definition for the external developer
│   └── bindings
│       ├── admin-binding.yaml     # Binding for the admin role
│       ├── qa-dev-binding.yaml    # Binding for the QA developer role
│       └── ext-dev-binding.yaml    # Binding for the external developer role
├── scripts
│   ├── create-ca.sh              # Script to create root and intermediate CAs
│   └── create-certs.sh           # Script to create user certificates
└── README.md                     # Documentation for the project
```

## Setup Instructions

1. **Install cert-manager**: Follow the official cert-manager installation guide to set up cert-manager in your Kubernetes cluster.

2. **Create the Root CA**: Use the `scripts/create-ca.sh` script to generate the root and intermediate CAs.

3. **Create User Certificates**: Run the `scripts/create-certs.sh` script to create certificates for the admin, QA developer, and external developer.

4. **Apply Configurations**: Apply the YAML files located in the `src` directory to your Kubernetes cluster to set up roles and bindings.

## Usage Guidelines

- Ensure that the Kubernetes cluster is properly configured and that you have the necessary permissions to create resources.
- Modify the YAML files as needed to fit your specific requirements.
- Monitor the certificates and renew them as necessary based on their validity periods.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.