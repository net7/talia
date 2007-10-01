require File.dirname(__FILE__) + "/../lib/talia_core"

require 'active_record/fixtures'

@@fixtures = [ 'source_records', 'dirty_relation_records', 'type_records']

# Check for the tesly adapter, and load it if it's there
if(File.exists?(File.dirname(__FILE__) + '/tesly_reporter.rb'))
  printf("Continuing with tesly \n")
  require File.dirname(__FILE__) + '/tesly_reporter'
end


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
          dbconfig = YAML::load(File.open(File.dirname(__FILE__) + '/../config/database.yml')) 
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
    
    # Flush the database
    def self.flush_db
      @@fixtures.reverse.each { |f| ActiveRecord::Base.connection.execute "DELETE FROM #{f}" }
    end
    
    # Setup the fixtures
    def self.fixtures
      flush_db
      fixture_files = @@fixtures.collect { |f| File.join(File.dirname(__FILE__), "#{f}.yml") }
      fixture_files.each do |fixture_file|
        Fixtures.create_fixtures(File.dirname(__FILE__) + '/fixtures', File.basename(fixture_file, '.*'))  
      end  
    end
    
    # Flush the RDF store
    def self.flush_rdf
      to_delete = Query.new.select(:s, :p, :o).where(:s, :p, :o).execute
      to_delete.each do |s, p, o|
        FederationManager.delete(s, p, o)
      end
    end
    
    # Creates a dummy Source and saves it
    def self.make_dummy_source(uri)
      src = Source.new(uri)
      src.workflow_state = 0
      src.primary_source = 1
      src.save!
      return src
    end
    
  end

end