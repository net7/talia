# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

Rake::RDocTask.new(:rdoc_cc) do |rdoc|
  rdoc.rdoc_files.include("app/**/*rb")
  rdoc.rdoc_dir = ENV['CC_BUILD_ARTIFACTS'] + '/rdoc_app' if(ENV['CC_BUILD_ARTIFACTS'])
end

task :cruise <= ['test', 'rdoc_cc']


