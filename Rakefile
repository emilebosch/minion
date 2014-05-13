require 'rake/testtask'
require './lib/minion/version'

NAME='minion'

Rake::TestTask.new do |t|
  t.libs << "lib/#{NAME}.rb"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

task :build => :clean do 
  `gem build minion.gemspec`
end

task :clean do
  `rm -f *.gem`
end

task :uninstall do
  `gem uninstall minion -ax`
  `rbenv rehash`
end

task :install => :uninstall  do
  `gem install --local minion-#{Minion::VERSION}.gem`
  `rbenv rehash`
end

task :default => :test