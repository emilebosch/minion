require 'rubygems'
require 'bundler'
Bundler.setup
require 'minion'

MinionCI::Settings.init(true)
run MinionCI::Server