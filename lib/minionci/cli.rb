require 'thor'

module MinionCI
  class Cli < Thor
    default_task :start

    desc "start", "Start minion"
    def start(domain=nil, key=ENV['GROK'])
      Settings.init(false)
      Process.spawn("ngrok","--log=stdout","-authtoken=#{key}","--subdomain=#{domain}","4567") if domain
      Server.run!
    end

    desc "build [commit]", "Build a certain commit"
    def build(commit)
      Settings.init(false)
      Worker.new.build commit
    end
  end
end