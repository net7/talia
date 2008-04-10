# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

task :cruise => ['doc:app', 'test']
# Helper task for the pre-checkin smoke check
task :smoke => ['test', 'talia_core:test', 'widgeon:test']
