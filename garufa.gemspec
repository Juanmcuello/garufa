# -*- encoding: utf-8 -*-
# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'garufa/version'

spec = Gem::Specification.new

spec.name        = 'garufa'
spec.version     = Garufa::VERSION
spec.summary     = 'Websocket server compatible with Pusher.'
spec.description = 'A websocket server compatible with the Pusher protocol.'
spec.authors     = ['Juan Manuel Cuello']
spec.email       = ['juanmacuello@gmail.com']
spec.homepage    = 'https://github.com/Juanmcuello/garufa'
spec.bindir      = 'bin'
spec.license     = 'MIT'
spec.executables << 'garufa'
spec.required_ruby_version = '>=2.2.2'

spec.files = Dir[
  'LICENSE',
  'README.md',
  'Rakefile',
  'lib/**/*.rb',
  'lib/**/*.yajl',
  'bin/*',
  '*.gemspec',
  'test/*.*'
]

spec.add_dependency 'goliath', '1.0.6'
spec.add_dependency 'faye-websocket', '0.10.9'
spec.add_dependency 'websocket-driver', '0.7.1'
spec.add_dependency 'rack', '1.6.11'
spec.add_dependency 'roda', '3.23.0'
spec.add_dependency 'signature', '0.1.8'
spec.add_dependency 'tilt', '2.0.9'
spec.add_dependency 'yajl-ruby', '1.4.1'
spec.add_development_dependency 'rack-test', '0.8.3'
spec.add_development_dependency 'rake', '12.3.3'
spec.add_development_dependency 'minitest', '5.11.3'
spec
