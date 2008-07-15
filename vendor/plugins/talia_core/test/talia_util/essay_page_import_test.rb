require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class EssayPageImportTest < Test::Unit::TestCase
  
    include UtilTestMethods
    
    # Flush RDF before each test
    def setup
      setup_once(:flush) do
        clean_data_files
        TaliaCore::TestHelper.flush_rdf
        TaliaCore::TestHelper.flush_db
      end
      
      setup_once(:src) { hyper_import(load_doc('aventurelli-1,1')) }
    end
    
    # Test if the import succeeds
    def test_import
      assert_kind_of(TaliaCore::Source, @src)
    end
    
    # Test if the types were imported correctly
    def test_types
      assert_types(@src, N::HYPER + "EssayPage")
    end
    
    # Test the title property
    def test_title
      assert_property(@src.dcns::title)
    end
    
    # Test the ordering
    def test_position
      assert_property(@src.hyper::position, "1")
      assert_property(@src.hyper::position_name, "1")
    end
    
    # Test sub part relation
    def test_essay_relation
      assert_property(@src.hyper::part_of, N::LOCAL + "aventurelli-1")
    end
    
    # Test if the data file was imported
    def test_data
      assert_equal(1, @src.data_records.size)
      assert_kind_of(TaliaCore::DataTypes::XmlData, @src.data_records[0])
      assert_equal('aventurelli.html', @src.data_records[0].location)
    end
    
  end
end