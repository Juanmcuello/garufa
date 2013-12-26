Garufa
====

A websocket server compatible with the Pusher protocol.

**IMPORTANT:** Garufa is currently in alpha version, which means it is not
production ready, but you are free to use it and test it. Any feedback is
welcome.

Intro
-----

Garufa is a websocket server which implements the [Pusher][pusher] protocol. It
was built on top of [Goliath][goliath], a high performance non-blocking web
server.

It was based on [Slanger][slanger], another server compatible with Pusher.

[pusher]: http://pusher.com
[goliath]: https://github.com/postrank-labs/goliath/
[slanger]: https://github.com/stevegraham/slanger

Install
-------

Make sure you have a ruby version >= 1.9.2

``` console
$ gem install garufa --pre

$ garufa --help

$ garufa -sv -p 4567 --app_key my-application-key --secret my-secret-string
```
