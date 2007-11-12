$: << File.join(File.dirname(__FILE__))
load 'tasks/talia_core_tasks.rake'

desc 'Default: run unit tests.'
task :default => 'cruise'

task :cruise => ['talia_core:test', 'talia_core:rdoc']
