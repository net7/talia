require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class PageImportTest < Test::Unit::TestCase
  
    include UtilTestMethods
    
    # Establish the database connection for the test
    TaliaCore::TestHelper.startup
    
    
    # Flush RDF before each test
    def setup
      setup_once(:flush) do
        clean_data_files
        TaliaCore::TestHelper.flush_rdf
        TaliaCore::TestHelper.flush_db
      end
      
      setup_once(:src) { HyperImporter::Importer.import(load_doc('D-12,10r')) }
      setup_once(:work_src) { HyperImporter::Importer.import(load_doc('AC,1')) }
    end
    
    # Test if the import succeeds
    def test_import
      assert_kind_of(TaliaCore::Source, @src)
    end
    
    # Test if the types were imported correctly
    def test_types
      assert_types(@src, N::HYPER + "Manuscript", N::HYPER + "Page")
    end
    
    # Test the title property
    def test_title
      assert_property(@src.dcns::title, "D 12,10r")
    end
    
    # Test the ordering
    def test_position
      assert_property(@src.hyper::position, "15")
      assert_property(@src.hyper::position_name, "10r")
    end
    
    # Test the dimensions
    def test_dimensions
      assert_property(@src.hyper::height, "3778.00")
      assert_property(@src.hyper::width, "2700.00")
    end
    
    # Test work import
    def test_work_page
      assert_types(@work_src, N::HYPER + "Page", N::HYPER + "Work")
      assert_equal(N::LOCAL + "AC,1", @work_src.uri)
    end
    
    # Test sub part relation
    def test_book_relation
      assert_property(@src.hyper::part_of, N::LOCAL + "D-12")
    end
    
    # Test source name
    def test_siglum
      assert_equal(N::LOCAL + "D-12,10r", @src.uri)
    end
    
  end
end
