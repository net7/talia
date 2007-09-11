require 'simpleassert'
require 'semantic_naming'
require 'active_support'
require 'active_record'
require 'active_rdf'
require 'source'

module TaliaCore
  
  # The TaliaCore initializer is responsible for setting up the Talia core
  # system, e.g. making the neccessary connections, setting up the
  # basic namespaces, etc.
  # The basic mechanism works like the Rails initializer
  #
  # The initializer will automatically configure the namespace shortcuts
  # for rdf: and rdfs:
  class Initializer
    
    # The configuration hash that was used to initialize
    # the system is stored for later reference
    cattr_reader :config
    
    # Indicates if the system has been initialized
    cattr_reader :initialized
    @@initialized = false
    
    # Indicates if the initialization was started, 
    # but not finished
    cattr_reader :init_started
    @@init_started = false
    
    # Runs the initialization. You can pass a block to this method, which
    # is run with one parameter: A hash containing the configuration.
    # 
    # For now, the values are documented in the code below
    def self.run(&initializer)
      raise(SystemInitializationError, "System cannot be initialized twice") if(@@initialized || @@init_started)
      
      @@init_started = true
      
      # See create_default_config to see the options
      config = create_default_config()
      
      # Call the user code
      initializer.call(config) if(initializer)
      
      # Initialize the database connection
      if(config["standalone_db"])
        ActiveRecord::Base.establish_connection(config["db_connection"])
        ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))
      end
      
      # Initialize the ActiveRDF connection
      ConnectionPool.add_data_source(config["rdf_connection"])
      
      # Register the local name
      N::Namespace.shortcut(:local, config["local_uri"])
      
      # Register the default name
      N::Namespace.shortcut(:default, config["default_namespace_uri"])
      
      # Register the RDF namespace
      N::Namespace.shortcut(:rdf, "http://www.w3.org/1999/02/22-rdf-syntax-ns#")
      
      # Register the RDFS namespace
      N::Namespace.shortcut(:rdfs, "http://www.w3.org/2000/01/rdf-schema#")
      
      # Register additional namespaces
      if(config["namespaces"])
        sassert_type(config["namespaces"], Hash)
        config["namespaces"].each_pair do |shortcut, uri|
          N::Namespace.shortcut(shortcut, uri)
        end
      end
      
      # set the $ASSERT flag
      if(config["assert"])
        $ASSERT = true
      end
      
      @@initialized = true
      
      # Configuration will be frozen and stored
      config.freeze
      @@config = config
    end
    
    
    
  protected
  
    # Creates the default values for the config hash
    def self.create_default_config
      config = Hash.new
      
      # The name of the local node
      config["local_uri"] = "http://test.dummy/"
      
      # The "default" namespace
      config["default_namespace_uri"] = "http://default.dummy/"
      
      # Connect options for ActiveRDF
      # Defaults to in-memory RDFLite
      config["rdf_connection"] = {
        :type => :rdflite
      }
      
      # Indicates if the DB backend (ActiveRecord) is 
      # used "standalone", which means "outside" a
      # rails application. 
      # For the standalone case, the Talia
      # initializer will make the database connections.
      # Otherwise, Rails will handle that.
      config["standalone_db"] = false
      
      # Configuration for standalone database connection
      config["db_connection"] = nil
      
      # Additional namespaces that will be registered at 
      # startup. If present, this is expected to be a Hash with 
      # :shortcut => URI pairs
      config["namespaces"] = nil
      
      # Whether to set the $ASSERT flag that activates the simple assertions
      config["assert"] = true
      
      return config
    end
    
    
  end
end