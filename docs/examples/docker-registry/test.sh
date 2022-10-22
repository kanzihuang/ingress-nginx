#!/bin/bash

set -eu

certs=~/certs
server=registry.123sou.cn

curl https://$server/v2/ --cacert $certs/ca.crt --key $certs/client.key --cert $certs/client.cert -v

sudo rm -rf /etc/docker/certs.d/$server
sudo mkdir -p /etc/docker/certs.d/$server
sudo cp $certs/ca.crt $certs/client.key $certs/client.cert /etc/docker/certs.d/$server

docker tag registry:2.6.2 $server/registry:2.6.2
docker push $server/registry:2.6.2
