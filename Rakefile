# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require(File.join(File.dirname(__FILE__), 'config', 'boot'))
  require 'tasks/rails'

  desc 'Generate documentation for the talia_core plugin.'
  Rake::RDocTask.new(:rdoc_talia) do |rdoc|
    rdoc.title    = 'Talia Application'
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.rdoc_files.include('README.rdoc', 'vendor/plugins/talia_core/README.rdoc')
    rdoc.rdoc_files.include('lib/**/*.rb', 'vendor/plugins/talia_core/lib/**/*.rb')
  end
rescue Exception => e
  puts "Talia Core not installed (Exception: #{e.message}), loading developer tasks manually"
  if(Rake.application.options.trace)
    puts caller
  end
  load File.dirname(__FILE__) + '/lib/tasks/talia_dev.rake'
end

task :cruise => ['doc:app', 'test']
# Helper task for the pre-checkin smoke check
task :smoke => ['test', 'talia_core:test', 'widgeon:test']

