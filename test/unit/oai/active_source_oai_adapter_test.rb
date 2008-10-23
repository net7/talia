require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), '..', 'unit_test_helpers')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class ActiveSourceOaiAdapterTest < Test::Unit::TestCase
  
    include TaliaCore::UnitTestHelpers
    
    suppress_fixtures
    
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
      setup_once(:src) do 
        src = TaliaCore::Source.new("http://active_source_adapter_wrapper_test/test_source")
        src.dcns::title << 'title'
        src.dcns::format << 'format'
        src.dct::abstract << 'abstract'
        src.save!
        src
      end
      setup_once(:adapter) do
        TaliaCore::Oai::ActiveSourceOaiAdapter.new(@src)
      end
    end
    
    def test_fields
      assert_equal(@adapter.title, ['title'] )
      assert_equal(@adapter.format, ['format'])
      assert_equal(@adapter.abstract, ['abstract'])
    end
    
    def test_get_wrapper_for_specific
      book = TaliaCore::Book.new('http://as_adapter_test/wrapper_test/book')
      test_wrapper = TaliaCore::Oai::ActiveSourceOaiAdapter.get_wrapper_for(book)
      assert_kind_of(TaliaCore::Oai::BookAdapter, test_wrapper)
    end
    
    def test_get_wrapper_for_unspecific
      path_step = TaliaCore::PathStep.new('http://as_adapter_test/wrapper_test/pathstep')
      test_wrapper = TaliaCore::Oai::ActiveSourceOaiAdapter.get_wrapper_for(path_step)
      assert_kind_of(TaliaCore::Oai::ActiveSourceOaiAdapter, test_wrapper)
    end
    
    
  end
end