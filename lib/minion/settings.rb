require 'yaml'

module Minion
  class Settings
    class << self 
      
      def init(run_worker=false)
        %w(logs queue).each { | d | FileUtils.mkdir_p "./data/#{d}"}
        Worker.new.start! if run_worker
      end

      def config
        defaults.merge YAML.load_file config_file if exist?
      end

      def exist?
        File.exists? config_file
      end

      def defaults
        {
          "repo_dir"  => "./data/repo",
          "queue_dir" => "./data/queue"
        }
      end

      def save(settings)
        File.write config_file, YAML.dump(settings)
        @config = nil
      end

      def config_file
        "./data/config.yml" 
      end      
    end
  end 
end