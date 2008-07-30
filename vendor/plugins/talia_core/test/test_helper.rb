$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'test/unit'
require "talia_core"
require "talia_util/test_helpers"
require 'active_support/testing'
require 'active_support/test_case'
require 'active_record/fixtures'

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
    
  end
  
  TestHelper.startup
  Test::Unit::TestCase.fixture_path=File.join(File.dirname(__FILE__), 'fixtures')
  Test::Unit::TestCase.set_fixture_class :active_sources => TaliaCore::ActiveSource,
    :semantic_properties => TaliaCore::SemanticProperty,
    :semantic_relations => TaliaCore::SemanticRelation,
    :sources => TaliaCore::Source,
    :data_records => TaliaCore::DataTypes::DataRecord

end
