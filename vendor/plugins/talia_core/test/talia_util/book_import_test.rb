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
      setup_once(:flush) do
        clean_data_files
        TaliaCore::TestHelper.flush_rdf
        TaliaCore::TestHelper.flush_db
      end
      setup_once(:src) do
        HyperImporter::Importer.import(load_doc('Mp-XIV-2'))
      end
      setup_once(:work_src) { HyperImporter::Importer.import(load_doc('WS')) }
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
      assert_property(@src.hyper::is_in_archive, N::LOCAL + 'Goethe- und Schiller-Archiv')
    end
    
    # Test the title property
    def test_title
      assert_property(@src.dcns::title, "MpXIV2")
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
      assert_equal(N::LOCAL + "WS", @work_src.uri)
    end
    
    def test_date
      assert_property(@work_src.dcns::date, '1880')
    end
    
    def test_publisher
      assert_property(@work_src.dcns::publisher, 'Ernst Schmeitzner')
    end
    
    def test_publishing_place
      assert_property(@work_src.hyper::publication_place, 'Chemnitz')
    end
    
    # Test source name
    def test_name
      assert_equal(N::LOCAL + "Mp-XIV-2", @src.uri)
    end
    
    def test_copyright
      assert_property(@work_src.hyper::copyright_note, '© Stiftung Weimarer Klassik und Kunstsammlungen, Goethe- und Schiller-Archiv, Weimar 2003')
    end
    
  end
end
