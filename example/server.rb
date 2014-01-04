require 'pusher'

Pusher.host = 'localhost'
Pusher.port = 8080

Pusher.app_id = 'my_app'
Pusher.key = 'my-appication-key'
Pusher.secret = 'my-application-secret'

Pusher.trigger('my-channel', 'my-event', { message: 'hello world' })
