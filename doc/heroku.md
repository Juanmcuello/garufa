Setting up Garufa on Heroku
---------------------------

Create a repo for your app:

```
$ mkdir garufa-heroku
$ cd garufa-heroku
$ git init .
```

Create Gemfile and Procfile files:

``` ruby
# Gemfile
source 'http://rubygems.org'
ruby '2.1.2'
gem 'garufa'

# Procfile
web: garufa -v --app_key $GARUFA_APP_KEY --secret $GARUFA_SECRET -p $PORT
```

Generate Gemfile.lock and commit your changes:
```
$ bundle install
$ git add .
$ git commit -m 'Initial commit'
```

Create your app, set environment variables and deploy:

```
$ heroku create
$ heroku config:set GARUFA_APP_KEY=app-key
$ heroku config:set GARUFA_SECRET=app-secret
$ git push heroku master
```

At this point you should have Garufa up and listening on port 80.

Set `Pusher.port` and `Pusher.ws_port` in the example above to port 80, and
`Pusher.host` to the name of your app provided by Heroku (something like
`random-name-2323.herokuapp.com`).
