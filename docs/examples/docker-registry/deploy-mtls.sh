#!/bin/bash

set -eu

server=registry.123sou.cn
certs=~/certs

sudo rm -rf /etc/docker/certs.d/$server
sudo mkdir -p /etc/docker/certs.d/$server
sudo cp $certs/ca.crt $certs/client.key $certs/client.cert /etc/docker/certs.d/$server

kubectl -n docker-registry delete secret registry-tls --ignore-not-found
kubectl -n docker-registry create secret generic registry-tls --from-file tls.crt=$certs/server.crt --from-file tls.key=$certs/server.key --from-file ca.crt=$certs/ca.crt
kubectl -n docker-registry apply -f ingress-with-mtls.yaml
