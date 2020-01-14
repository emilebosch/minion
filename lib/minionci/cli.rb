require "thor"

module MinionCI
  class Cli < Thor
    default_task :start

    desc "start", "Start minion"

    def start(domain = nil, key = ENV["GROK"])
      App.init(true)
      Process.spawn("ngrok", "--log=stdout", "-authtoken=#{key}", "--subdomain=#{domain}", "4567") if domain
      Server.run!
    end

    desc "build [commit]", "Build a certain commit"

    def build(commit)
      App.init(false)
      Worker.new.build commit
    end

    desc "reset", "Removes all data and starts a clean CI"

    def reset
      FileUtils.rm_rf("./data")
    end
  end
end
