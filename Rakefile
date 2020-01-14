require "rake/testtask"
require "./lib/minionci/version"

NAME = "minionci"

Rake::TestTask.new do |t|
  t.libs << "lib/#{NAME}.rb"
  t.test_files = FileList["test/*_test.rb"]
  t.verbose = true
end

task :build => :clean do
  `gem build #{NAME}.gemspec`
end

task :clean do
  `rm -f *.gem`
end

task :uninstall do
  `gem uninstall #{NAME} -ax`
  `rbenv rehash`
end

task :install => :uninstall do
  `gem install --local #{NAME}-#{MinionCI::VERSION}.gem`
  `rbenv rehash`
end

task :default => :test
