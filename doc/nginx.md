Using Nginx as reverse proxy
----------------------------

You can set Garufa behind Nginx if you want: http://nginx.org/en/docs/http/websocket.html

Take into account that you will need to set *proxy_read_timeout* to a value a little
higher than Pusher *ACTIVITY_TIMEOUT*, otherwise Nginx will close the connection.

In addition, you can let Ngnix take care of SSL and start Garufa without SSL enabled.
You could use something like this in your Nginx configuration.

```
upstream garufa {
    server 127.0.0.1:8000;
}

map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    listen       8080;
    server_name  garufa.example.com;

    ; Set this a little higher than Pusher ACTIVITY_TIMEOUT
    proxy_read_timeout  150;

    ssl                  on;
    ssl_certificate      /path/to/cert.pem;
    ssl_certificate_key  /path/to/cert.key;

    location / {
        proxy_pass          http://garufa;
        proxy_http_version  1.1;
        proxy_set_header    Upgrade $http_upgrade;
        proxy_set_header    Connection $connection_upgrade;
    }
}
```
