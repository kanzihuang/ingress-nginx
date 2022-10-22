#!/bin/bash

set -eu

server=registry.123sou.cn
# subjectAltName=DNS.1:*.123sou.cn,DNS.2:*.hwanli.cn
certs=~/certs

# rm -rf $certs && mkdir -p $certs && pushd $certs
# openssl req -x509 -sha256 -newkey rsa:2048 -keyout ca.key -out ca.crt -days 356 -nodes -subj '/CN=123sou.cn'
# openssl req -new -newkey rsa:2048 -keyout server.key -out server.csr -nodes -subj "/CN=The server of 123sou.cn" \
#   -reqexts SAN \
#   -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=$subjectAltName"))
# openssl x509 -req -sha256 -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt \
#   -extfile <(printf "subjectAltName=$subjectAltName")
# openssl req -new -newkey rsa:2048 -keyout client.key -out client.csr -nodes -subj '/CN=The client of 123sou.cn'
# openssl x509 -req -sha256 -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out client.cert
# openssl pkcs12 -export -clcerts -in client.cert -inkey client.key -out client.p12 -password "pass:"

sudo rm -rf /etc/docker/certs.d/$server
sudo mkdir -p /etc/docker/certs.d/$server
sudo cp $certs/ca.crt $certs/client.key $certs/client.cert /etc/docker/certs.d/$server
# popd

kubectl -n docker-registry delete secret registry-tls --ignore-not-found
kubectl create secret generic registry-tls --from-file tls.crt=$certs/server.crt --from-file tls.key=$certs/server.key --from-file ca.crt=$certs/ca.crt
kubectl apply -f ingress-with-mtls.yaml
