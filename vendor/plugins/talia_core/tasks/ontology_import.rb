# Script to use to import RDFS ontologies
$: << File.dirname(__FILE__) + '/vendor/plugins/ActiveRDF/lib/'

require 'rake'
require 'yaml'
require 'lib/talia_core'

task :default => :import

task :import do
  # some useful constants
  TITLE = "\nImport-Ontologies Rake file\nVersion: 1.0 by Michele Nucci (mik.nucci _at_ gmail.com) \n\n"
  
  puts TITLE
  
  # read the command line parameters
  # example: rake -f import-ontologies rdfdir=./rdf/ontologies/ [resetdb=1|0|y|n]
  #
  # parameters:
  # rdfdir:         the path of the directory in which the ontologies are stored
  # resetdb:        completly reset the DB before import the ontology file (initialize a new DB)
  # ontologysyntax: (optionals for ntriples) specify the ontology syntas ntriples/rdfxml
  rdfdir          = ENV['rdfdir']
  resetdb         = ENV['reset']
  ontology_syntax = ENV['ontologysyntax']
  environment     = ENV['environment'] ? ENV['environment'] : 'development'
  
  if rdfdir
    # check if the specified directory really exists
    if !FileTest.exists?(rdfdir)
      puts "Error: the specified directory does not exists!\n\n"
      exit(1)
    end
    
    # find RDF/RDFS files
    puts "--> Start finding RDF/RDFS file to load...\n"
    
    # get the file list (only rdf and rdfs file)
    file_list = Dir[rdfdir+'*.{rdf,rdfs}']
    
    if file_list.size > 0
      puts "\tFound " << file_list.size.to_s << " files."
      puts "--> Try to importing rdf/rdfs file into the triple-store..."
      
      # read triplestore configuration file
      # check for exception in opening the triplestore configuration file
      configfile = File.join(File.dirname(__FILE__), '..', 'config', 'rdfstore.yml')
      begin
        tps_config = {}
        YAML.load_file(configfile)[environment].each { |key, value| tps_config[key.to_sym] = value }
      rescue
        puts "\nERROR: #{configfile} does not exists or it is impossible to read it.\n\n"
        exit(1)
      end
      
      # open a connection to the triple-store to load the found files
      if resetdb && ( resetdb == 1 || resetdb.downcase == 'y' )
        tps_config[:new] = 'yes'
      end
      
      adapter = ConnectionPool.add_data_source(tps_config)
      

      # check if the connection to te triplestore is ok...otherwise exit the script
      if !adapter
        puts "\nERROR: impossible to open a connection to the triples store. Check your system and your configuration files!\n\n"
        exit(1)
      end
      
      # try to load every file into the triple store
      file_list.each{|file|
        puts "\tLoading: " << file.to_s
        
        # load rdf/rdfs file into triplestore
        begin
          if ontology_syntax
            adapter.load(file, ontology_syntax)
          else
            adapter.load(file)
          end
        rescue
          puts "\tProblem loading: " << file.to_s << ". File not loaded!"
        end
      }
      
      adapter.save
      
      puts "\n--> Importing rdf/rdfs file: complete!\n\n"
    end
    
  else
    # basic parameters not specified
    puts "Syntax example: rake -f import-ontologies rdfdir=./rdf/ontologies/ [resetdb=n|y] [ontologysyntax=rdfxml|ntriples]"
  end
  
end