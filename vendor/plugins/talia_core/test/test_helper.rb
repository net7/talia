require File.dirname(__FILE__) + "/../lib/talia_core"

require 'active_record/fixtures'

module TaliaCore
  
  class TestHelper
    
    # connect the database
    def self.startup
      if(!TaliaCore::Initializer.initialized)
        # run the initializer
        TaliaCore::Initializer.run do |config|
          
          # The name of the local node
          config["local_uri"] = "http://localnode.org/"
          
          # The "default" namespace
          config["default_namespace_uri"] = "http://default.talia.eu/"
          
          # Connect options for ActiveRDF
          # Defaults to in-memory RDFLite
          config["rdf_connection"] = {
            :type => :rdflite # In memory, so we don't have to clean the database 
          }
          
          # Indicates if the DB backend (ActiveRecord) is 
          # used "standalone", which means "outside" a
          # rails application. 
          # For the standalone case, the Talia
          # initializer will make the database connections.
          # Otherwise, Rails will handle that.
          config["standalone_db"] = true
          
          # Configuration for standalone database connection
          dbconfig = YAML::load(File.open('config/database.yml')) 
          config["db_connection"] = dbconfig["test"]
          
          # Additional namespaces that will be registered at 
          # startup. If present, this is expected to be a Hash with 
          # :shortcut => URI pairs
          config["namespaces"] = {
            :test => "http://testnamespace.com/",
            :foo => "http://foo.com/"
          }
        end
      end
    end
    
    # Setup the fixtures
    def self.fixtures
      fixtures = Dir.glob(File.join(File.dirname(__FILE__), 'fixtures', '*.{yml,csv}'))  
      fixtures.each do |fixture_file|  
        Fixtures.create_fixtures(File.dirname(__FILE__) + '/fixtures', File.basename(fixture_file, '.*'))  
      end 
    end
    
  end

end