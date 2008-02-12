require 'test/unit'

# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class BookImportTest < Test::Unit::TestCase
  
    include UtilTestMethods
    
    # Establish the database connection for the test
    TaliaCore::TestHelper.startup
    
    
    # Flush RDF before each test
    def setup
      setup_once(:src) do
        TaliaCore::TestHelper.flush_rdf
        TaliaCore::TestHelper.flush_db
        HyperImporter::Importer.import(load_doc('book_manuscript'))
      end
      setup_once(:work_src) { HyperImporter::Importer.import(load_doc('book_work')) }
    end
    
    # Test if the import succeeds
    def test_import
      assert_kind_of(TaliaCore::Source, @src)
    end
    
    # Test if the types were imported correctly
    def test_types
      assert_types(@src, N::HYPER + "Dossier", N::HYPER + "Book")
    end
    
    def test_in_archive
      puts "*** Warning: This is still missing from the export!"
    end
    
    # Test the title property
    def test_title
      assert_property(@src.dcns::title, "Goethe- und Schiller-Archiv")
    end
    
    # Test the ordering
    def test_ordering
      assert_property(@src.hyper::position, "0")
    end
    
    # Test the description field
    def test_description
      assert_property(@src.dcns::description, "Mp-XIV-2 description")
    end
    
    # Test work import
    def test_work_book
      assert_types(@work_src, N::HYPER + "Book", N::HYPER + "PrintedAndDistributed")
      assert_equal(N::LOCAL + "AC", @work_src.uri)
    end
    
    # Test source name
    def test_name
      assert_equal(N::LOCAL + "Mp-XIV-2", @src.uri)
    end
    
  end
end
