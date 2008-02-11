require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class ChapterImportTest < Test::Unit::TestCase
  
    # Establish the database connection for the test
    TaliaCore::TestHelper.startup
    
    
    # Flush RDF before each test
    def setup
      unless(@src)
        TaliaCore::TestHelper.flush_rdf
        TaliaCore::TestHelper.flush_db
      end
      @src = HyperImporter::Importer.import(UtilHelper.load_doc('chapter'))
    end
    
    # Test if the import succeeds
    def test_import
      assert_kind_of(TaliaCore::Source, @src)
    end
    
    # Test if the types were imported correctly
    def test_types
      assert_equal(2, @src.types.size)
      assert(@src.types[0] == N::HYPER + "Chapter" || @src.types[0] == N::HYPER + "Work", "Failed on types: #{@src.types[0]}, #{@src.types[1]}")
      assert(@src.types[1] == N::HYPER + "Chapter" || @src.types[1] == N::HYPER + "Work")
      assert_not_equal(@src.types[0], @src.types[1])
    end
    
    # Test the title property
    def test_title
      assert_equal(1, @src.dcns::title.size)
      assert_equal("[Text]", @src.dcns::title[0])
    end
    
    # Test the ordering
    def test_ordering
      assert_equal(1, @src.hyper::position.size)
      assert_equal("2", @src.hyper::position[0])
    end
    
    # Test the first page
    def test_first_page
      assert_equal(1, @src.hyper::first_page.size)
      assert_kind_of(TaliaCore::Source, @src.hyper::first_page[0])
      assert_equal(N::LOCAL + "AC,[Text]", @src.hyper::first_page[0].uri)
    end
    
    # Test source name
    def test_siglum
      assert_equal(N::LOCAL + "AC-[Text]", @src.uri)
    end
    
    # Test the name
    def test_name
      assert_equal(1, @src.hyper::name.size)
      assert_equal("[Text]", @src.hyper::name[0])
    end
    
  end
end
