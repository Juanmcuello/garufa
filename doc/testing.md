Testing and Contributing
------------------------

It's up to you how you install Garufa dependencies for development and testing,
just be sure you have installed dependencies listed in the .gemspec. If you want
to let *bundler* handle this, you can generate a Gemfile from the .gemspec and
then run *bundle install*.


``` console
$ bundle init --gemspec=garufa.gemspec
$ bundle install
```

Once you have dependencies installed, run *rake test* (or just *rake*).

``` console
$ rake
```

Pull requests are welcome!

