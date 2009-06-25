require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class PageImportTest < Test::Unit::TestCase
  
    include UtilTestMethods
    
    suppress_fixtures
    
    # Flush RDF before each test
    def setup
      flush_once_for_import_test
      setup_once(:src) { hyper_import(load_doc('D-12,10r')) }
      setup_once(:work_src) { hyper_import(load_doc('AC,1')) }
    end
    
    # Test if the import succeeds
    def test_import
      assert_kind_of(TaliaCore::Page, @src)
    end
    
    # Caused error during Hyper import tests
    def test_k6_problem
      hyper_import(load_doc('K-6,101[1]'))
    end
    
    # Test if the types were imported correctly
    def test_types
      assert_types(@src, N::HYPER + "Manuscript", N::HYPER + "Page")
    end
    
    # Test the title property
    def test_title
      assert_property(@src.dcns::title, "D 12,10r")
    end
    
    # Test title on RDF
    def test_rdf_title
      assert_equal(@src.my_rdf[N::DCNS.title].first, "D 12,10r")
    end
    
    # Test the ordering
    def test_position
      assert_property(@src.hyper::position, "000015")
      assert_property(@src.hyper::position_name, "10r")
    end
    
    # Test the dimensions
    def test_dimensions
      assert_property(@src.dct::extent, "2700.00x3778.00 pixel")
      assert_equal(@src.dimensions, "2700.00x3778.00 pixel")
    end
    
    # Test work import
    def test_work_page
      assert_types(@work_src, N::HYPER + "Page", N::HYPER + "Work")
      assert_equal(N::LOCAL + "AC,1", @work_src.uri)
    end
    
    # Test sub part relation
    def test_book_relation
      assert_property(@src.dct::isPartOf, N::LOCAL + "D-12")
    end

    def test_book_relation_rdf
      assert_equal(1, @src.my_rdf[N::DCT.isPartOf].size)
      assert_equal(N::LOCAL + "D-12", @src.my_rdf[N::DCT.isPartOf].first.uri)
    end
    
    # Test source name
    def test_uri
      assert_equal(N::LOCAL + "D-12,10r", @src.uri)
    end
    
    def test_siglum
      assert_equal('D-12,10r', @src.siglum)
    end
    
    def test_ordering_import
      # We have to "cast" this, because the import will only create a dummy
      # source, not a real book object
      raw_book = @src.dct::isPartOf[0]
      assert(raw_book)
      book = TaliaCore::Book.new(raw_book)
      assert_equal(@src, book.ordered_pages.at(15))
    end
    
  end
end
