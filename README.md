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
server and based on [Slanger][slanger], another server compatible with Pusher.

[pusher]: http://pusher.com
[goliath]: https://github.com/postrank-labs/goliath/
[slanger]: https://github.com/stevegraham/slanger

Install
-------

Make sure you have a ruby version >= 1.9.2

``` console
$ gem install garufa --pre

$ garufa --help
```

Example
-------

Create an *index.html* file:

``` html
<html>
  <script src="http://js.pusher.com/2.1/pusher.min.js"></script>
  <script>
    Pusher.log = function(message) { console.log(message) }
    Pusher.host = 'localhost'
    Pusher.ws_port = 8080

    var appKey = 'my-application-key'
    var pusher = new Pusher(appKey)
    var channel = pusher.subscribe('my-channel')

    channel.bind('my-event', function(data) { alert(data.message) })
  </script>
</html>
```

For ruby, create a *server.rb* file:
``` ruby
# server.rb
require 'pusher'

Pusher.host = 'localhost'
Pusher.port = 8080

Pusher.app_id = 'my_app'
Pusher.key = 'my-appication-key'
Pusher.secret = 'my-application-secret'

Pusher.trigger('my-channel', 'my-event', { message: 'hello world' })
```

1. Start `garufa` server:

   ``` console
   $ garufa -sv --app_key my-application-key --secret my-application-secret
   ```

2. Point your browser to the `index.html` you created.

3. Execute the `server.rb` script:

   ``` console
   $ ruby server.rb
   ```
