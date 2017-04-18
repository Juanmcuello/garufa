Health endpoint
---------------

Garufa provides an endpoint (/healthz) for checking the health of the server,
which responses with a 204 status code to GET and HEAD requests:

```console
$ curl -i http://garufa.example.com:8000/healthz
HTTP/1.1 204 No Content
Content-Type: text/html
Content-Length: 0
Server: Goliath
Date: Tue, 18 Apr 2017 00:37:43 GMT

```
This endpoint is particularly useful when sitting many Garufa servers behind a
load balancer. The load balancer can use this endpoint for checking the health
of each server and remove it from the cluster when is not available.
