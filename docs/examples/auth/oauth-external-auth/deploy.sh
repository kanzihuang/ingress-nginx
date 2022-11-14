#!/bin/bash

set -eu

certs=~/certs
kubectl -n kube-system delete secret kubernetes-dashboard-certs --ignore-not-found
kubectl -n kube-system create secret generic kubernetes-dashboard-certs --from-file tls.crt=$certs/server.crt --from-file tls.key=$certs/server.key
kubectl -n kube-system apply -f dashboard-ingress.yaml,oauth2-proxy.yaml
