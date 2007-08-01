require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'rubygems'
gem 'activerecord'

require 'active_record'
require 'active_record/fixtures'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the talia_core plugin.'
task :test => [ :testdb_migrate, :fixtures ]
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the talia_core plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = ENV["CC_BUILD_ARTIFACTS"] ? ENV["CC_BUILD_ARTIFACTS"] + "/core_rdoc" : 'rdoc'
  rdoc.title    = 'TaliaCore'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Load fixtures into the current database.  Load specific fixtures using FIXTURES=x,y"  
task :fixtures => :testdb_connect do  
  fixtures = ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(File.dirname(__FILE__), 'test', 'fixtures', '*.{yml,csv}'))  
  fixtures.each do |fixture_file|  
    Fixtures.create_fixtures('test/fixtures', File.basename(fixture_file, '.*'))  
  end  
end  

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"  
task :testdb_migrate => :testdb_connect do  
   ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )  
end  

desc 'Connect the database'
task :testdb_connect do
  dbconfig = YAML::load(File.open('config/database.yml'))
  ActiveRecord::Base.establish_connection(dbconfig["test"])
  ActiveRecord::Base.logger = Logger.new(File.open('test/database.log', 'a'))
end

task :cruise => ['test', 'rdoc']
