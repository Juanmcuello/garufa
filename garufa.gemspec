# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'garufa/version'

Gem::Specification.new do |s|
  s.name        = "garufa"
  s.version     = Garufa::VERSION
  s.summary     = "Websocket server compatible with Pusher."
  s.description = "Garufa is a websocket server compatible with the Pusher protocol."
  s.authors     = ["Juan Manuel Cuello"]
  s.email       = ["juanmacuello@gmail.com"]
  s.homepage    = "http://github.com/Juanmcuello/garufa"
  s.bindir      = 'bin'
  s.executables << 'garufa'

  s.files = Dir[
    "LICENSE",
    "README.md",
    "Rakefile",
    "lib/**/*.rb",
    "bin/*",
    "*.gemspec",
    "test/*.*"
  ]

  s.add_dependency "goliath"
  s.add_dependency "faye-websocket", '~> 0.7.2'
  s.add_dependency "cuba"
  s.add_dependency "signature"
  s.add_development_dependency "rake"
  s.add_development_dependency "minitest", '~> 5.3.1'
end
