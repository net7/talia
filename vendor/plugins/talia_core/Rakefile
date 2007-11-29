# This file is only for the tasks that are used only for "standalone" mode, and
# for development. All other tasks go to "tasks/", and are available both 
# in Rails and in standalone mode.

require 'fileutils'
require 'rake/gempackagetask'


# Some general setup stuff

TALIA_VERSION = "0.0.1"

$: << File.join(File.dirname(__FILE__))
load 'tasks/talia_core_tasks.rake'

desc "Load fixtures into the current database.  Load specific fixtures using FIXTURES=x,y"  
task :fixtures => "talia_core:talia_init" do
  load_fixtures 
end  

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"  
task :migrate => [:local_migrations, "talia_core:talia_init"] do
  do_migrations 
  puts "Migrations done."
end  


# DEVELOPMENT TASKS

## Creates the Talia core dependencies on the given gem spec.
#def create_deps(gemspec)
#  gemspec.add_dependency
#end
#
## Gem spec for the developer gem
#developer_spec = Gem::Specifcation.new do |spec|
#  spec.version = TALIA_VERSION
#  spec.author = "Talia dev team"
#  spec.platform = Grem::Platform::RUBY
#  spec.required_ruby_version = '>= 1.8.6'
#  spec.date = Time.now
#  
#  create_deps(spec)
#end
#
## Gem spec for the standard talia gem
#talia_spec = Gem::Sepcification.new do |spec|
#  
#end

# This is just a quick hack to use the migrations in standalone mode
desc "Copies the template migrations to the local migrations directory"
task :local_migrations do 
  migrations = [  
    "create_source_records",
    "create_dirty_relation_records",
    "create_data_records", 
    "create_type_records"
    ]
  
  template_dir = File.join(File.dirname(__FILE__), "generators", "talia_migrations", "templates")
  dest_dir = File.join(File.dirname(__FILE__), "db", "migrate")
  dest_backup = File.join(File.dirname(__FILE__), "db", "migrate_old")
  src_files = FileList.new(File.join(template_dir, "*"))
  
  unless(src_files.size == migrations.size) 
    puts "The number of templates doesn't match the configured numbe"
    puts "Please update this rake task"
    return -1
  end
  
  if(FileTest.exists?(dest_dir))
    FileUtils.mv(dest_dir, dest_backup) 
    puts "Old migrations backed up"
  end
  FileUtils.makedirs(dest_dir)
  
  
  (1..migrations.size).each do |num|
    prefix = "%03d" % num
    template = File.join(template_dir, migrations[num-1])
    destination = File.join(dest_dir, "#{prefix}_#{migrations[num-1]}.rb")
    FileUtils.cp(template, destination)
    puts "Copied: #{template} -> #{destination}"
  end
end

desc 'Default: run unit tests.'
task :default => 'cruise'

task :cruise => ['local_migrations', 'talia_core:test', 'talia_core:rdoc']
