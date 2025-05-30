#!/bin/bash

# Create a Root CA with a validity of 50 years
openssl genrsa -out rootCA.key 4096
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 18250 -out rootCA.pem -subj "/C=US/ST=State/L=City/O=Organization/CN=Root CA"

# Create an Intermediate CA with a validity of 15 years
openssl genrsa -out intermediateCA.key 4096
openssl req -new -key intermediateCA.key -out intermediateCA.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=Intermediate CA"
openssl x509 -req -in intermediateCA.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out intermediateCA.pem -days 5475 -sha256

# Output the created certificates
echo "Root CA and Intermediate CA have been created."
echo "Root CA: rootCA.pem"
echo "Intermediate CA: intermediateCA.pem"