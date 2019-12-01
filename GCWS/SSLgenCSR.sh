#!/bin/bash
read -p "Common Name: " cname
read -p "emailAddress: " email
read -p "Organization: " org
read -p "Organizational Unit: " ou
read -p "City: " city
read -p "State: " state
read -p "Country: " country
read -p "Subject Alternative Names (Style as DNS: www.foo.com,  DNS: bar.foo.com etc..): " san

cat > $cname.conf << EOF1
[ req ]
default_bits = 2048
prompt = no
encrypt_key = no
default_md = sha256
distinguished_name = dn
req_extensions = req_ext
[ dn ]
CN = $cname
emailAddress = $email
O = $org
OU = $ou
L = $city
ST = $state
C = $country
[ req_ext ]
subjectAltName = $san
EOF1

openssl req -new -config $cname.conf -keyout $cname.key -out $cname.csr

echo "Confirming CSR:"
openssl req -text -noout -verify -in $cname.csr
