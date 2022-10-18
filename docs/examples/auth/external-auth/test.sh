curl http://ingress-nginx-controller.ingress-nginx -v -H 'Host: external-auth-01.sample.com' -u 'foo:bar'
curl http://ingress-nginx-controller.ingress-nginx -v -H 'Host: external-auth-01.sample.com' -u 'user:passwd'
