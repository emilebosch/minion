module MinionCI
  class Server < Sinatra::Base
    register Sinatra::Partial
    set :partial_template_engine, :slim

    get "/" do
      redirect "/setup" unless App.configured?
      slim :queue
    end

    post "/hook" do
      body = request.body.read
      puts "Hook called with body: #{body}"

      pr = JSON.parse body
      return unless pr["pull_request"]
      commit = pr["pull_request"]["head"]["sha"][0..6]

      File.write "#{App.config["queue_dir"]}/#{commit}.json", JSON.pretty_generate(pr)
    end

    post "/setup" do
      App.save params[:settings]
      redirect "/"
    end

    get "/setup" do
      slim :setup
    end

    get "/log/:id" do
      @log = File.read "./data/logs/#{params[:id]}.log"
      slim :log
    end

    get "/status" do
      slim :status
    end
  end
end
