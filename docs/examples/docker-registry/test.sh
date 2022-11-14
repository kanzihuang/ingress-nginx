#!/bin/bash

set -eu

certs=~/certs
server=registry.123sou.cn
port=$(kubectl -n ingress-nginx get svc ingress-nginx-controller -o jsonpath="{.spec.ports[?(@.name=='https')].nodePort}")

curl https://$server/v2/ --cacert $certs/ca.crt --key $certs/client.key --cert $certs/client.cert -v && echo

docker tag registry:2.6.2 $server:$port/registry:2.6.2
docker push $server:$port/registry:2.6.2
