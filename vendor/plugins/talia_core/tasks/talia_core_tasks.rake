# Rake tasks for the talia core
$: << File.join(File.dirname(__FILE__), '..', 'lib') # For Talia core

require 'rake'
require 'yaml'
require 'talia_core'
require 'talia_util'
require 'talia_util/util'
require 'rake/testtask'
require 'rake/rdoctask'
require 'progressbar'

include TaliaUtil

namespace :talia_core do
  
  # Standard initialization
  desc "Initialize the TaliaCore"
  task :talia_init do
    Util::title
    Util::init_talia
    TLoad::force_rails_parts
    Util::talia_config if(Util::flag?('verbose'))
  end
  
  # Removes all data
  desc "Reset the Talia data store"
  task :clear_store => :talia_init do
    Util::flush_db
    Util::flush_rdf
    puts "Flushed data store"
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
    RdfImport::import(ENV['rdf_syntax'], TaliaUtil::Util::get_files)
  end

  desc "Update the Ontologies. Options [ontologies=<ontology_folder>]"
  task :setup_ontologies => :talia_init do
    Util::setup_ontologies
  end

  # Rewrite your base URL. This will loose any comments in the config file
  desc "Rewrite the database to move it to a new URL. Options new_home=<url>."
  task :move_site => :talia_init do
    new_site = ENV['new_home']
    # Check if this looks like an URL
    raise(RuntimeError, "Illegal new_home given. (It must start with http(s):// and end with a slash)") unless(new_site =~ /^https?:\/\/\S+\/$/)
    # open up the configuration file
    config_file_path = File.join(TALIA_ROOT, 'config', 'talia_core.yml')
    config = YAML::load(File.open(config_file_path))
    old_site = config['local_uri']
    raise(RuntimeError, "Could not determine current local URI") unless(old_site && old_site.strip != '')
    puts "New home URL: #{new_site}"
    puts "Original home URL: #{old_site}"
    # Rewrite the sql database
    ActiveRecord::Base.connection.execute("UPDATE active_sources SET uri = replace(uri, '#{old_site}', '#{new_site}')")
    puts('Updated database, now recreating RDF')
    # Rebuild the RDF
    prog = ProgressBar.new('Rebuilding', Util::rewrite_count)
    Util::rewrite_rdf { prog.inc }
    prog.finish
    # Rebuild the ontologies
    Util::setup_ontologies
    # Write back to the config file
    config['local_uri'] = new_site
    open(config_file_path, 'w') { |io| io.puts(config.to_yaml) }
    puts "New configuration saved. Finished site rebuilding."
  end

  # Task for importing YAML data into the data store
  desc "Import YAML data file in Talia format."
  task :yaml_import => :talia_init do
    YamlImport::import_multi_files(TaliaUtil::Util::get_files)
  end
  
  # Task for updating the OWL classes with RDFS class information
  desc "Update OWL classes with RDFS class information."
  task :owl_to_rdfs_update => :talia_init do
    RdfUpdate::owl_to_rdfs
  end
  
  # Task to import data files into the Talia system
  desc "Import data files. Options data_type=<data_type> replace_files={yes|no}"
  task :data_import => :talia_init do
    DataImport::import(TaliaUtil::Util::get_files, ENV['data_type'])
  end
  
  # Task to import demo data from a demo directory
  desc "Import demo data (for default demo data). Opions: demodir=<dir> [owlify=no]"
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
    if(ENV['owlify'].to_s.downcase == 'yes')
      RdfUpdate::owl_to_rdfs
    end
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

  desc "Rebuild the RDF store from the database. Option [hard_reset=(true|false)]"
  task :rebuild_rdf => :talia_init do
    count = TaliaCore::SemanticRelation.count
    puts "Rebuilding RDF for #{count} triples."
    prog = ProgressBar.new('Rebuilding', count)
    Util::rewrite_rdf { prog.inc }
    prog.finish
    puts "Finished rewriting. ATTENTION: You may want to call setup_ontologies now."
  end
  
end