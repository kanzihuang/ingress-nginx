#!/bin/bash
set -eu

server=registry.hwanli.cn
certs=$(cd $(dirname $0) && pwd)/certs

rm -r $certs && mkdir $certs && pushd $certs
openssl req -x509 -sha256 -newkey rsa:2048 -keyout ca.key -out ca.crt -days 356 -nodes -subj '/CN=My Cert Authority'
openssl req -new -newkey rsa:2048 -nodes -keyout tls.key -out tls.csr \
  -subj "/C=CN/ST=Beijing/L=Beijing/O=Home/OU=Devops/CN=$server" \
  -reqexts SAN \
  -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:$server"))
openssl x509 -req -days 365 \
  -in tls.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -extfile <(printf "subjectAltName=DNS:$server") \
  -out tls.crt
sudo rm -r /etc/docker/certs.d/$server
sudo mkdir /etc/docker/certs.d/$server
sudo cp ca.crt /etc/docker/certs.d/$server
popd

kubectl -n docker-registry delete secret registry-tls --ignore-not-found
kubectl create secret generic registry-tls --from-file tls.crt=$certs/tls.crt --from-file tls.key=$certs/tls.key
kubectl apply -f ingress-with-tls.yaml
