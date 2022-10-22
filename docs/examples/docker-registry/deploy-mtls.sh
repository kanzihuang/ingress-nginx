#!/bin/bash

set -eu

server=registry.hwanli.cn
certs=$(cd $(dirname $0) && pwd)/certs

rm -r $certs && mkdir $certs && pushd $certs
openssl req -x509 -sha256 -newkey rsa:2048 -keyout ca.key -out ca.crt -days 356 -nodes -subj '/CN=My Cert Authority'
openssl req -new -newkey rsa:2048 -keyout server.key -out server.csr -nodes -subj '/CN=$server' \
  -reqexts SAN \
  -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:$server"))
openssl x509 -req -sha256 -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt \
  -extfile <(printf "subjectAltName=DNS:$server")
openssl req -new -newkey rsa:2048 -keyout client.key -out client.csr -nodes -subj '/CN=My Client'
openssl x509 -req -sha256 -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out client.cert
sudo rm -r /etc/docker/certs.d/$server
sudo mkdir /etc/docker/certs.d/$server
sudo cp ca.crt client.key client.cert /etc/docker/certs.d/$server
popd

kubectl -n docker-registry delete secret registry-tls --ignore-not-found
kubectl create secret generic registry-tls --from-file tls.crt=$certs/server.crt --from-file tls.key=$certs/server.key --from-file ca.crt=$certs/ca.crt
kubectl apply -f ingress-with-mtls.yaml
