#!/bin/bash

set -eu

server=mydomain.com
curl https://$server --resolve "$server:443:127.0.0.1" -v --cacert ca.crt --key client.key --cert client.crt
