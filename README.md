[![Build Status](https://travis-ci.org/Juanmcuello/garufa.png?branch=master)](https://travis-ci.org/Juanmcuello/garufa)
[![Code Climate](https://codeclimate.com/github/Juanmcuello/garufa/badges/gpa.svg)](https://codeclimate.com/github/Juanmcuello/garufa)

![logo](./doc/images/logo.png)

Garufa
====

An open source server implementation of the [Pusher][pusher] protocol.

Intro
-----

Garufa is a Ruby websocket server which implements the Pusher protocol. It is
built on top of [Goliath][goliath], a high performance non-blocking web server,
and inspired by [Slanger][slanger], another server compatible with Pusher.

Documentation
-------------

* [Installation and usage] (/doc/install.md)
* [SSL Support] (/doc/ssl.md)
* [Deploy to Heroku] (/doc/heroku.md)
* [Using Nginx as reverse proxy] (/doc/nginx.md)
* [Cheking number of current connections] (/doc/connections.md)
* [Testing and contributing] (/doc/testing.md)

Pusher
------

[Pusher][pusher] is a great service, very well documented and with excellent
support. Consider using it on production.

[pusher]: http://pusher.com
[goliath]: https://github.com/postrank-labs/goliath/
[slanger]: https://github.com/stevegraham/slanger
