require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class PathStepImportTest < Test::Unit::TestCase
  
    include UtilTestMethods
    
    suppress_fixtures
    
    # Flush RDF before each test
    def setup
      flush_once_for_import_test
      setup_once(:src) { hyper_import(load_doc('igerike-927,1')) }
    end
    
    # Test if the import succeeds
    def test_import
      assert_kind_of(TaliaCore::PathStep, @src)
    end
    
        # Test source name
    def test_uri
      assert_equal(N::LOCAL + "igerike-927,1", @src.uri)
    end
    
    def test_siglum
      assert_property(@src.hyper::siglum, 'igerike-927,1')
    end
    
    # Test if the types were imported correctly
    def test_types
      assert_types(@src, N::HYPER.PathStep)
    end
    
    # Test the ordering
    def test_ordering
      assert_property(@src.hyper::position, "000001")
    end
    
    # Test the description field
    def test_description
      # Useless, but didn't seem to find one with description
      assert_equal(0, @src.dcns::description.size)
    end
    
    def test_part_of
      assert_property(@src.dct::isPartOf, N::LOCAL + 'igerike-927')
    end
    
    def test_related_document
      assert_property(@src.dcns::relation, N::LOCAL + 'N-IV-1,17[2]')
    end
    
  end
end
