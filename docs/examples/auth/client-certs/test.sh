#!/bin/bash

set -eu

server=mydomain.com
curl https://$server --resolve "$server:443:127.0.0.1" -v --cacert certs/ca.crt --key certs/client.key --cert certs/client.crt
