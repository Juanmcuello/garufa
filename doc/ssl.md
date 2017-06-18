SSL support
-----------

```shell
$ garufa -sv --app_key app-key --secret app-secret --ssl --ssl-cert /path/to/cert.pem --ssl-key /path/to/cert.key
```

Garufa uses the same port for API messages and websocket connections. This means
that if you start the server with SSL enabled, you will have to enable SSL in
the client library as well as in the api client.

An alternative is to setup Garufa behind a reverse proxy such as Nginx and let
the proxy take care of SSL. See [Using Nginx as reverse proxy](/doc/nginx.md).
