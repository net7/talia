# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require(File.join(File.dirname(__FILE__), 'config', 'boot'))
  require 'tasks/rails'
rescue Exception => e
  puts "Talia Core not installed (Exception: #{e.message}), loading developer tasks manually"
  load File.dirname(__FILE__) + '/lib/tasks/talia_dev.rake'
end

task :cruise => ['doc:app', 'test']
# Helper task for the pre-checkin smoke check
task :smoke => ['test', 'talia_core:test', 'widgeon:test']
