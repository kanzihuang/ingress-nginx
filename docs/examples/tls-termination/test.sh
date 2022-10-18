#!/bin/bash

set -eu

server=foo.bar.com
echo quit | openssl s_client -showcerts -servername $server -connect $server:443 | sed -n '/^-*BEGIN CERTIFICATE-*$/,/^-*END CERTIFICATE-*$/p' > cacert.pem
curl https://$server --resolve "$server:443:127.0.0.1" -v --cacert cacert.pem
