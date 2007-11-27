require 'fileutils'

$: << File.join(File.dirname(__FILE__))
load 'tasks/talia_core_tasks.rake'

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
