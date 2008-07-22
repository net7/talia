$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'test/unit'
require "talia_core"
require "talia_util/test_helpers"
require 'active_support/testing'
require 'active_support/test_case'
require 'active_record/fixtures'

@@flush_tables = [ 'active_sources', 'semantic_relations', 'semantic_properties', 'data_records', 'workflows' ]

module TaliaCore
#  class Source
#    public :instantiate_source_or_rdf_object
#  end
  
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
      @@flush_tables.reverse.each { |f| ActiveRecord::Base.connection.execute "DELETE FROM #{f}" }
      Fixtures.reset_cache if(@@new_ar) # We must reset the cache because the fixtures were deleted
    end
    
    # Flush the RDF store
    def self.flush_rdf
      to_delete = Query.new.select(:s, :p, :o).where(:s, :p, :o).execute
      to_delete.each do |s, p, o|
        FederationManager.delete(s, p, o)
      end
    end
    
    # Creates a dummy Source and saves it
    def self.make_dummy_source(uri, *types)
      src = Source.new(uri)
      src.primary_source = true
      types.each do |t| 
        ActiveSource.new(t).save! unless(ActiveSource.exists?(:uri => t.to_s))
        src.types << t 
      end
      src.save!
      return src
    end
    
    def self.data_record_files
      return ['1', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13']
    end
    
  end
  
  TestHelper.startup
  Test::Unit::TestCase.fixture_path=File.join(File.dirname(__FILE__), 'fixtures')
  Test::Unit::TestCase.set_fixture_class :active_sources => TaliaCore::ActiveSource,
    :semantic_properties => TaliaCore::SemanticProperty,
    :semantic_relations => TaliaCore::SemanticRelation,
    :sources => TaliaCore::Source,
    :data_records => TaliaCore::DataTypes::DataRecord

end
