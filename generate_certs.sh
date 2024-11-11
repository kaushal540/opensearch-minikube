#!/bin/bash

# Directory to store the generated certificates
CERTS_DIR="certificates"
CA_DIR="${CERTS_DIR}/ca"
OPENSEARCH_DIR="${CERTS_DIR}/opensearch"
DASHBOARDS_DIR="${CERTS_DIR}/dashboards"

# Create directories for CA, OpenSearch, and Dashboards certificates
mkdir -p "${CA_DIR}" "${OPENSEARCH_DIR}" "${DASHBOARDS_DIR}"

# 1. Generate CA Key and Certificate
echo "Generating CA private key..."
openssl genpkey -algorithm RSA -out "${CA_DIR}/ca.key" -pkeyopt rsa_keygen_bits:2048

echo "Generating CA certificate..."
openssl req -new -x509 -key "${CA_DIR}/ca.key" -sha256 -days 3650 -out "${CA_DIR}/ca.pem" -subj "/C=US/ST=CA/L=SanFrancisco/O=ExampleOrg/CN=ExampleRootCA"

# 2. Generate OpenSearch Key and CSR
echo "Generating OpenSearch private key..."
openssl genpkey -algorithm RSA -out "${OPENSEARCH_DIR}/opensearch.key" -pkeyopt rsa_keygen_bits:2048

echo "Generating OpenSearch CSR..."
openssl req -new -key "${OPENSEARCH_DIR}/opensearch.key" -out "${OPENSEARCH_DIR}/opensearch.csr" -subj "/C=US/ST=CA/L=SanFrancisco/O=ExampleOrg/CN=opensearch.local"

# 3. Sign the OpenSearch CSR with the CA to create the OpenSearch Certificate
echo "Signing OpenSearch certificate with CA..."
openssl x509 -req -in "${OPENSEARCH_DIR}/opensearch.csr" -CA "${CA_DIR}/ca.pem" -CAkey "${CA_DIR}/ca.key" -CAcreateserial -out "${OPENSEARCH_DIR}/opensearch.pem" -days 365 -sha256

# 4. Generate OpenSearch Dashboards Key and CSR
echo "Generating OpenSearch Dashboards private key..."
openssl genpkey -algorithm RSA -out "${DASHBOARDS_DIR}/dashboards.key" -pkeyopt rsa_keygen_bits:2048

echo "Generating OpenSearch Dashboards CSR..."
openssl req -new -key "${DASHBOARDS_DIR}/dashboards.key" -out "${DASHBOARDS_DIR}/dashboards.csr" -subj "/C=US/ST=CA/L=SanFrancisco/O=ExampleOrg/CN=opensearch-dashboards.local"

# 5. Sign the OpenSearch Dashboards CSR with the CA to create the Dashboards Certificate
echo "Signing OpenSearch Dashboards certificate with CA..."
openssl x509 -req -in "${DASHBOARDS_DIR}/dashboards.csr" -CA "${CA_DIR}/ca.pem" -CAkey "${CA_DIR}/ca.key" -CAcreateserial -out "${DASHBOARDS_DIR}/dashboards.pem" -days 365 -sha256

# 6. Clean up CSR files
rm "${OPENSEARCH_DIR}/opensearch.csr"
rm "${DASHBOARDS_DIR}/dashboards.csr"

echo "Certificates generated successfully."
echo "CA Certificate: ${CA_DIR}/ca.pem"
echo "OpenSearch Key: ${OPENSEARCH_DIR}/opensearch.key"
echo "OpenSearch Certificate: ${OPENSEARCH_DIR}/opensearch.pem"
echo "OpenSearch Dashboards Key: ${DASHBOARDS_DIR}/dashboards.key"
echo "OpenSearch Dashboards Certificate: ${DASHBOARDS_DIR}/dashboards.pem"

# Adjusting permissions
chmod 700 certificates/{ca,opensearch,dashboards}
chmod 600 certificates/{ca/*,opensearch/*,dashboards/*}
