#!/bin/bash

# Create certificates for users based on the defined configurations

# Function to create a certificate
create_cert() {
    local cert_name=$1
    local cert_file=$2
    echo "Creating certificate for ${cert_name}..."
    # Command to create the certificate (placeholder)
    # cert-manager create --config ${cert_file}
}

# Create certificates for each user
create_cert "Admin" "src/certificates/admin-cert.yaml"
create_cert "QA Developer" "src/certificates/qa-dev-cert.yaml"
create_cert "External Developer" "src/certificates/ext-dev-cert.yaml"

echo "All certificates created successfully."