#!/bin/bash

set -eu

certs_dir=$(cd $(dirname $0) && pwd)/certs
mkdir -p $certs_dir && pushd $certs_dir

openssl req -x509 -sha256 -newkey rsa:2048 -keyout ca.key -out ca.crt -days 356 -nodes -subj '/CN=My Cert Authority'

openssl req -new -newkey rsa:2048 -keyout server.key -out server.csr -nodes -subj '/CN=mydomain.com'
openssl x509 -req -sha256 -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

openssl req -new -newkey rsa:2048 -keyout client.key -out client.csr -nodes -subj '/CN=My Client'
openssl x509 -req -sha256 -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out client.crt
openssl pkcs12 -export -clcerts -in client.crt -inkey client.key -out client.p12 -password "pass:"

kubectl delete secret tls-secret --ignore-not-found
kubectl create secret generic tls-secret --from-file=tls.crt=server.crt --from-file=tls.key=server.key --from-file=ca.crt=ca.crt

popd

kubectl apply -f ingress.yaml 
