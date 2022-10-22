#!/bin/bash

set -eu

server=registry.hwanli.cn
docker tag registry:2.6.2 $server/registry:2.6.2
docker push $server/registry:2.6.2
