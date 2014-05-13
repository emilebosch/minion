require 'thor'

module Minion
  class Cli < Thor
    default_task :start

    desc "start", "Start minion"
    def start
      Minion::Settings.init(true)
      Server.run!
    end

    desc "build [commit]", "Build a certain commit"
    def build(commit)
      Minion::Settings.init(false)
      Worker.new.build commit
    end
  end
end