require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class CatalogImportTest < Test::Unit::TestCase

    include UtilTestMethods

    suppress_fixtures

    # Flush RDF before each test
    def setup
      flush_once_for_import_test
      setup_once(:src) { hyper_import(load_doc('catalog')) }
    end

    # Test if the import succeeds
    def test_import
      assert_kind_of(TaliaCore::Catalog, @src)
    end

    def test_siglum
      assert_equal(@src.siglum, 'DEF')
    end

    def test_position
      assert_equal('2', @src.position)
    end

  end
end