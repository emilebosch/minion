require 'rubygems'
require 'bundler'
Bundler.setup
require 'minion'

Minion::Settings.init(true)
run Minion::Server