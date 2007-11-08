require File.dirname(__FILE__) + "/../lib/talia_core"

require 'active_record/fixtures'

@@fixtures = [ 'source_records', 'type_records', 'data_records', 'dirty_relation_records']

# Check for the tesly adapter, and load it if it's there
if(File.exists?(File.dirname(__FILE__) + '/tesly_reporter.rb'))
  printf("Continuing with tesly \n")
  require File.dirname(__FILE__) + '/tesly_reporter'
end


module TaliaCore
  
  class TestHelper

    # Check if we have old (1.2.3-Rails) style ActiveRecord without fixture cache
    @@new_ar = Fixtures.respond_to?(:reset_cache)
    
    # connect the database
    def self.startup
      if(!TaliaCore::Initializer.initialized)
        TaliaCore::Initializer.talia_root = File.join(File.dirname(__FILE__))
        TaliaCore::Initializer.environment = "test"
        # run the initializer
        TaliaCore::Initializer.run("talia_core")
      end
    end
    
    # Flush the database
    def self.flush_db
      @@fixtures.reverse.each { |f| ActiveRecord::Base.connection.execute "DELETE FROM #{f}" }
      Fixtures.reset_cache if(@@new_ar) # We must reset the cache because the fixtures were deleted
    end
    
    # Setup the fixtures
    def self.fixtures
      flush_db unless(@@new_ar) # When fixtures are cached, there will be no default remove (which fails due to relational constraints)
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
