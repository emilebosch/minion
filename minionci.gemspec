require './lib/minionci/version'

Gem::Specification.new do |s|
  s.name        = 'minionci'
  s.version     = MinionCI::VERSION
  s.date        = '2013-11-05'
  s.summary     = "Deploy Github PR with ease on Dokku"
  s.description = "Allows you to automatically deploy github pull requests on Dokku"

  s.authors     = ["Emile Bosch"]
  s.email       = 'emilebosch@me.com'
  s.files       = Dir.glob('{lib}/**/*') + %w(README.md config.ru minionci.gemspec Gemfile)
  s.homepage    = 'https://github.com/emilebosch/minion'
  s.license     = 'MIT'
  s.executables << 'minionci'

  s.add_dependency 'sinatra'
  s.add_dependency 'slim'
  s.add_dependency 'tilt', '>= 1.3.4', '~> 1.3'
  s.add_dependency 'sass'
  s.add_dependency 'sinatra-partial'
  s.add_dependency 'bundler'
  s.add_dependency 'thor'
  s.add_dependency 'hashie'

   s.add_development_dependency 'rake' 
end