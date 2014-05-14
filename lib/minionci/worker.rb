module MinionCI
  class Worker 

    def start!
      Thread.new { process! }
    end

    def build(commit)
      next_up = pop || return
      FileUtils.mv next_up, "#{next_up}.processing"

      pr = JSON.parse(File.read "#{next_up}.processing")['pull_request']
      
      server      = config["server"]
      repo_dir    = config["repo_dir"]

      commit      = pr['head']['sha']
      branch      = pr['head']['ref']
      git_url     = pr['head']['repo']['ssh_url']
      report_url  = pr['statuses_url']

      app         = "pr-#{branch}"

      FileUtils.rm_r repo_dir, :force => true if Dir.exists? repo_dir

      report report_url, :pending, commit
      run "git clone --bare #{git_url} #{repo_dir} 2>&1",    "Cloning app"

      # pre
      run "ssh -t #{server} postgresql:delete #{app}",  "Cleaning up existing containers"
      run "ssh -t #{server} delete #{app}"
      run "ssh -t #{server} postgresql:create #{app}"

      # core
      run "cd #{repo_dir} && git remote add #{app} #{server}:#{app}", "Adding remote"
      run "cd #{repo_dir} && git push -f #{app} #{branch}:master 2>&1"

      # post
      run "ssh -t #{server} postgresql:link #{app} #{app}"
      run "ssh -t #{server} run #{app} rake db:migrate db:seed"

      # check deploy url
      # check test results
      run "ssh -t #{server} url #{app}"

      report report_url, :success, commit
      FileUtils.mv "#{next_up}.processing", "#{next_up}.done"
    end

    protected

    def process!
      puts "-> Running worker..." 
      @running = true

      while running? do
        sleep 1  
        next unless next_up = pop
        pr = JSON.parse(File.read next_up)['pull_request']
        commit = pr['head']['sha']
        puts "-> Building #{commit}.." 
        system("bundle exec minionci build #{commit} > ./data/logs/#{commit}.log")
      end
    end  

    def run(command, announce=nil)
      puts "-----> #{announce}" if announce
      puts "       #{command}"
      system(command)
    end

    def pop
      queue_dir = config["queue_dir"]
      Dir["#{queue_dir}/*.json"].sort_by { |f| File.mtime(f)}.first
    end    

    def report(url, state, commit)
      status  = 
      {
        state: state.to_s, 
        target_url: "http://#{App.config['host']}/log/#{commit}"
      }
      token   = config["token"]      
      run "curl --silent #{url}?access_token=#{token} -H \"Content-Type: application/json\" -X POST -d '#{status.to_json}' &>/dev/null", "Setting commit status: #{state}"
    end
   
    def config
      App.config
    end

    def running? 
      @running
    end
  end
end