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

desc 'Generate documentation for the talia_core plugin.'
Rake::RDocTask.new(:rdoc_talia) do |rdoc|
  rdoc.title    = 'Talia Application'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc', 'vendor/plugins/talia_core/README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb', 'vendor/plugins/talia_core/lib/**/*.rb')
end