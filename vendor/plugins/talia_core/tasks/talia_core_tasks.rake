# Rake tasks for the talia core
$: << File.dirname(__FILE__)
$: << File.join(File.dirname(__FILE__), '..', 'lib') # For Talia core

require 'rake'
require 'yaml'
require 'talia_core'
require 'talia_util/talia_util'
require 'rake/testtask'
require 'rake/rdoctask'

# Require helpers
require 'rdf_import'
require 'yaml_import'
require 'data_import'

include TaliaUtil

namespace :talia_core do
  
    # Standard initialization
  desc "Initialize the TaliaCore"
  task :talia_init do
    title
    init_talia
    talia_config if(flag?('verbose'))
  end
  
  # Init for the unit tests
  desc "Initialize Talia for the tests"
  task :test_setup do
    unless(ENV['environment'])
      puts "Setting environment to 'test'"
      ENV['environment'] = "test"
    end

    # Invoke the init after the setup
    Rake::Task["talia_core:talia_init"].invoke
  end
  
  # Test task
  desc 'Test the talia_core plugin.'
  task :test => :test_setup
  # Create the test tasks
  Rake::TestTask.new(:test) do |t| 
    t.libs << 'lib'
    # This will always take the files from the talia_core directory
    t.test_files = FileList["#{File.dirname(__FILE__)}/../test/**/*_test.rb"]
    t.verbose = true
  end
  

  desc 'Generate documentation for the talia_core plugin.'
  Rake::RDocTask.new(:rdoc) do |rdoc|
    rdoc.title    = 'TaliaCore'
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.rdoc_files.include('README')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
  
  # Just run the Talia init to test it
  desc "Test the TaliaCore startup"
  task :init_test => :talia_init do
    talia_config
  end
 
  # Task for importing ontologies/raw RDF data
  desc "Import ontologies. Same as rdf_import."
  task :ontology_import => [:rdf_import] # ontology_import is just another name
  # The real import task
  desc "Import RDF data directly into the triple store. Option: rdf_syntax={ntriples|rdfxml}"
  task :rdf_import => :talia_init do
    rdf_import(ENV['rdf_syntax'], get_files)
  end
  
  # Task for importing YAML data into the data store
  desc "Import YAML data file in Talia format."
  task :yaml_import => :talia_init do
    yaml_import(get_files)
  end
  
  # Task to import data files into the Talia system
  desc "Import data files. Options data_type=<data_type> replace_files={yes|no}"
  task :data_import => :talia_init do
    import_data(get_files, ENV['data_type'])
  end
  
  # Task to import demo data from a demo directory
  desc "Import demo data (for default demo data). Opion: demodir=<dir>"
  task :demo_import do
    unless(demodir = ENV['demodir'])
      puts "ERROR: Need demodir option for import"
      print_options
      exit(1)
    end
    
    # Force some options to default
    ENV['reset_db'] = "yes" unless(ENV['reset_db'])
    ENV['reset_rdf'] = "yes" unless(ENV['reset_rdf'])
    
    # Invoke the init after the setup
    Rake::Task["talia_core:talia_init"].invoke
    
    puts "Importing ontologies..."
    rdf_import("rdfxml", FileList.new(File.join(demodir, '*.rdf*')))
    puts "Importing data records..."
    yaml_import([File.join(demodir, "demo_data.yml")])
    puts "Importing files..."
    Dir.foreach(File.join(demodir)) do |entry|
      if(FileTest.directory?(File.join(demodir,entry)) && entry != ".." && entry != "." && entry != ".svn")
        puts "Importing for type #{entry}"
        import_data(FileList.new(File.join(demodir, entry, '*')), entry)
      end
    end
  end
  
  # Help info
  desc "Help on general options for the TaliaCore tasks"
  task :help do
    title
    puts "Talia Core tasks usage information."
    print_options
  end
  
  desc "Load fixtures into the current database.  Load specific fixtures using FIXTURES=x,y"  
  task :fixtures => :talia_init do
    load_fixtures 
  end  
  
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"  
  task :migrate => :talia_init do
    do_migrations  
  end  

end