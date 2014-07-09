[![Build Status](https://travis-ci.org/Juanmcuello/garufa.png?branch=master)](https://travis-ci.org/Juanmcuello/garufa)
[![Code Climate](https://codeclimate.com/github/Juanmcuello/garufa.png)](https://codeclimate.com/github/Juanmcuello/garufa)

Garufa
====

An open source server implementation of the [Pusher][pusher] protocol.

**IMPORTANT:** Garufa is currently in beta version, which means it is not
production ready, but you are free to use it and test it. Any feedback is
welcome.

Intro
-----

Garufa is a Ruby websocket server which implements the Pusher protocol. It is
built on top of [Goliath][goliath], a high performance non-blocking web server,
and inspired by [Slanger][slanger], another server compatible with Pusher.

Install
-------

Be sure you have a ruby version >= 1.9.2

``` console
$ gem install garufa --pre

$ garufa --help
```

Usage
-------

Start garufa server:

``` console
$ garufa -sv --app_key app-key --secret app-secret
```

This will start Garufa, logging to stdout in verbose mode. If you want Garufa
to run in background (daemonized) just add `-d` flag.

Now say you want to send events to your browser. Just create an .html file
which requires the *pusher.js* library and binds to some events, then point
your browser to that file (for testing purpouse, you can just simple open it
with your browser).

Maybe you would like to open your JavaScript console to see JavaScript debug
messages.

``` html
<html>
  <script src="http://js.pusher.com/2.1/pusher.min.js"></script>
  <script>
    Pusher.log = function(message) { console.log(message) };
    Pusher.host = 'localhost';
    Pusher.ws_port = 8080;

    var appKey = 'app-key';
    var pusher = new Pusher(appKey);
    var channel = pusher.subscribe('my-channel');

    channel.bind('my-event', function(data) { alert(data.message) });
  </script>
</html>
```

Now trigger *my-event* from Ruby code. Be sure you have already installed
the *pusher* gem (*gem install pusher*). Open a Ruby console and paste this
code:


``` ruby
require 'pusher'

Pusher.host = 'localhost'
Pusher.port = 8080

Pusher.app_id = 'my-app'
Pusher.key = 'app-key'
Pusher.secret = 'app-secret'

Pusher.trigger('my-channel', 'my-event', { message: 'hello world' })
```

Check your browser to see the event have just arrived.

SSL support
-----------

``` console
$ garufa -sv --app_key app-key --secret app-secret --ssl --ssl-cert /path/to/cert.pem --ssl-key /path/to/key.key
```

**NOTE**: At the moment, Garufa uses the same port for API messages and websocket
connections. This means that if you start the server with SSL enabled, you will
have to enable SSL in the client library as well as in the api client.

An alternative is to setup Garufa behind a reverse proxy such as Nginx and let the
proxy take care of SSL. See below for more info.


Using Nginx as reverse proxy
----------------------

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

    ssl                        on;
    ssl_certificate            /path/to/cert.pem;
    ssl_certificate_key        /path/to/cert.key;
    ssl_session_timeout        5m;
    ssl_ciphers                HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;

    location / {
        proxy_pass          http://garufa;
        proxy_http_version  1.1;
        proxy_set_header    Upgrade $http_upgrade;
        proxy_set_header    Connection $connection_upgrade;
    }
}
```

Testing and Contributing
------------------------

It's up to you how you install Garufa dependencies for development and testing,
just be sure you have installed dependencies listed in the .gemspec. If you want
to let *bundler* handle this, you can generate a Gemfile from the .gemspec and
then just run *bundle install*.


``` console
$ bundle init --gemspec=garufa.gemspec
$ bundle install
```

Once you have dependencies installed, run *rake test* (or just *rake*).

``` console
$ rake
```

Pull requests are welcome!


Pusher
------

[Pusher][pusher] is a great service, very well documented and with excellent
support. Consider using it on production.

[pusher]: http://pusher.com
[goliath]: https://github.com/postrank-labs/goliath/
[slanger]: https://github.com/stevegraham/slanger
