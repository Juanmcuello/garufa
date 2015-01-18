Installation and usage
----------------------

Be sure you have a ruby version >= 1.9.2

``` console
$ gem install garufa

$ garufa --help
```

Start garufa server:

``` console
$ garufa -sv --app_id app-id --app_key app-key --secret app-secret
```

This will start Garufa, logging to stdout in verbose mode. If you want Garufa
to run in background (daemonized) add `-d` flag.

Now say you want to send events to your browser. Create an .html file which
requires the *pusher.js* library and binds to some events, then point your
browser to that file (for testing purpose, you can simply open it with your
browser).

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
the *pusher* gem (*gem install pusher*). Open a Ruby console and paste this:


``` ruby
require 'pusher'

Pusher.host = 'localhost'
Pusher.port = 8080

Pusher.app_id = 'app-id'
Pusher.key = 'app-key'
Pusher.secret = 'app-secret'

Pusher.trigger('my-channel', 'my-event', { message: 'hello world' })
```

Check your browser to see the event have just arrived.
