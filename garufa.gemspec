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
spec.required_ruby_version = '>=1.9'

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

spec.add_dependency 'goliath', '1.0.5'
spec.add_dependency 'faye-websocket', '0.7.4'
spec.add_dependency 'websocket-driver', '0.3.5'
spec.add_dependency 'roda', '2.4.0'
spec.add_dependency 'signature', '0.1.7'
spec.add_dependency 'tilt', '2.0.1'
spec.add_dependency 'yajl-ruby', '1.3.0'
spec.add_development_dependency 'rack-test', '0.6.3'
spec.add_development_dependency 'rake', '10.3.2'
spec.add_development_dependency 'minitest', '5.4.0'
spec
