#!/bin/bash
set -eu

server=foo.bar.com
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=$server/O=$server"
kubectl delete secret tls-secret --ignore-not-found
kubectl create secret tls tls-secret --key tls.key --cert tls.crt
kubectl apply -f ingress.yaml
