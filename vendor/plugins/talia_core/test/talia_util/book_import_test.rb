require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class BookImportTest < Test::Unit::TestCase
  
    # Establish the database connection for the test
    TaliaCore::TestHelper.startup
    
    
    # Flush RDF before each test
    def setup
      unless(@src)
        TaliaCore::TestHelper.flush_rdf
        TaliaCore::TestHelper.flush_db
      end
      @src ||= HyperImporter::Importer.import(UtilHelper.load_doc('book_manuscript'))
      @work_src ||= HyperImporter::Importer.import(UtilHelper.load_doc('book_work'))
    end
    
    # Test if the import succeeds
    def test_import
      assert_kind_of(TaliaCore::Source, @src)
    end
    
    # Test if the types were imported correctly
    def test_types
      assert_kind_of(TaliaCore::Source, @src)
      assert_equal(2, @src.types.size)
      assert(@src.types[0] == N::HYPER + "Book" || @src.types[0] == N::HYPER + "Dossier")
      assert(@src.types[1] == N::HYPER + "Book" || @src.types[1] == N::HYPER + "Dossier")
      assert_not_equal(@src.types[0], @src.types[1])
    end
    
    def test_in_archive
      puts "*** Warning: This is still missing from the export!"
    end
    
    # Test the title property
    def test_title
      assert_equal(1, @src.dcns::title.size)
      assert_equal("Goethe- und Schiller-Archiv", @src.dcns::title[0])
    end
    
    # Test the ordering
    def test_ordering
      assert_equal(1, @src.hyper::position.size)
      assert_equal("0", @src.hyper::position[0])
    end
    
    # Test the description field
    def test_description
      assert_equal(1, @src.dcns::description.size)
      assert_equal("Mp-XIV-2 description", @src.dcns::description[0])
    end
    
    # Test work import
    def test_work_book
      assert_equal(2, @work_src.types.size)
      assert(@work_src.types[0] == N::HYPER + "Book" || @work_src.types[0] == N::HYPER + "PrintedAndDistributed")
      assert(@work_src.types[1] == N::HYPER + "Book" || @work_src.types[1] == N::HYPER + "PrintedAndDistributed")
      assert_not_equal(@work_src.types[0], @work_src.types[1])
      assert_equal(N::LOCAL + "AC", @work_src.uri)
    end
    
    # Test source name
    def test_name
      assert_equal(N::LOCAL + "Mp-XIV-2", @src.uri)
    end
    
  end
end
