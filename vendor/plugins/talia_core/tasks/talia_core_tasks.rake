# Rake tasks for the talia core
$: << File.join(File.dirname(__FILE__), '..', 'lib') # For Talia core

require 'rake'
require 'yaml'
require 'talia_core'
require 'talia_util'
require 'rake/testtask'
require 'rake/rdoctask'

include TaliaUtil

namespace :talia_core do
  
    # Standard initialization
  desc "Initialize the TaliaCore"
  task :talia_init do
    Util::title
    Util::init_talia
    Util::talia_config if(Util::flag?('verbose'))
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
    Util::talia_config
  end
 
  # Task for importing ontologies/raw RDF data
  desc "Import ontologies. Same as rdf_import."
  task :ontology_import => [:rdf_import] # ontology_import is just another name
  # The real import task
  desc "Import RDF data directly into the triple store. Option: rdf_syntax={ntriples|rdfxml}"
  task :rdf_import => :talia_init do
    RdfImport::import(ENV['rdf_syntax'], get_files)
  end
  
  # Task for importing YAML data into the data store
  desc "Import YAML data file in Talia format."
  task :yaml_import => :talia_init do
    YamlImport::import_multi_files(get_files)
  end
  
  # Task for updating the OWL classes with RDFS class information
  desc "Update OWL classes with RDFS class information."
  task :owl_to_rdfs_update => :talia_init do
    RdfUpdate::owl_to_rdfs
  end
  
  # Task to import data files into the Talia system
  desc "Import data files. Options data_type=<data_type> replace_files={yes|no}"
  task :data_import => :talia_init do
    DataImport::import(get_files, ENV['data_type'])
  end
  
  # Import from Hyper
  desc "Import data from Hyper. Options: base_url=<base_url> [list_path=?get_list=all] [doc_path=?get=] [user=<username> password=<pass>]"
  task :hyper_import => :talia_init do
    HyperXmlImport::set_auth(ENV['user'], ENV['password'])
    HyperXmlImport::import(ENV['base_url'], ENV['list_path'], ENV['doc_path'])
  end
  
  # Task to import demo data from a demo directory
  desc "Import demo data (for default demo data). Opion: demodir=<dir>"
  task :demo_import do
    unless(demodir = ENV['demodir'])
      puts "ERROR: Need demodir option for import"
      Util::print_options
      exit(1)
    end
    
    # Force some options to default
    ENV['reset_db'] = "yes" unless(ENV['reset_db'])
    ENV['reset_rdf'] = "yes" unless(ENV['reset_rdf'])
    
    # Invoke the init after the setup
    Rake::Task["talia_core:talia_init"].invoke
    
    puts "Importing ontologies..."
    RdfImport::import("rdfxml", FileList.new(File.join(demodir, '*.rdf*'), File.join(demodir, '*.owl')))
    puts "Importing data records..."
    YamlImport::import_multi_files([File.join(demodir, "demo_data.yml")])
    puts "Importing files..."
    Dir.foreach(File.join(demodir)) do |entry|
      if(FileTest.directory?(File.join(demodir,entry)) && entry != ".." && entry != "." && entry != ".svn")
        puts "Importing for type #{entry}"
        DataImport::import(FileList.new(File.join(demodir, entry, '*')), entry)
      end
    end
    RdfUpdate::owl_to_rdfs
  end
  
  # Helper task to bootstrap Redland RDF (should usually only be a problem when
  # using Redland with mysql store)
  desc "Initialize Redland RDF store. Option: rdfconf=<rdfconfig_file> [environment=env]"
  task :redland_init do
    # This simply activates the RDF store once with the :new option set.
    Util.title
    environment = ENV['environment'] || "development"
    raise(ArgumentError, "Must have rdfconf=<config_file>") unless(ENV['rdfconf'])
    options = YAML::load(File.open(ENV['rdfconf']))[environment]
    
    rdf_cfg = Hash.new
    options.each { |key, value| rdf_cfg[key.to_sym] = value }
    
    rdf_cfg[:new] = "yes"
    
    ConnectionPool.add_data_source(rdf_cfg)
  end
  
  # Help info
  desc "Help on general options for the TaliaCore tasks"
  task :help do
    Util.title
    puts "Talia Core tasks usage information."
    Util::print_options
  end

end