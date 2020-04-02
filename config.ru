require "rubygems"
require "bundler"
Bundler.setup
require "minion"

MinionCI::App.init(true)
run MinionCI::Server
