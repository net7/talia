require 'test/unit'
require 'rexml/document'

# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class EditionImportTest < Test::Unit::TestCase
  
    include UtilTestMethods
    
    suppress_fixtures
    
    # Flush RDF before each test
    def setup
      setup_once(:flush) do
        clean_data_files
        Util.flush_rdf
        Util.flush_db
        true
      end
      setup_once(:src) do
        hyper_import(load_doc('kbrunkhorst-93'))
      end
    end
    
    # Test if the import succeeds
    def test_import
      assert_kind_of(TaliaCore::Edition, @src)
    end
    
    # Test if the types were imported correctly
    def test_types
      assert_types(@src, N::HYPER + "HyperEdition", N::HYPER + "TEI")
    end
    
    # Test the title property
    def test_title
      assert_property(@src.dcns::title, "edition")
    end
    
    # Test source name
    def test_uri
      assert_equal(N::LOCAL + "kbrunkhorst-93", @src.uri)
    end
    
    def test_siglum
      assert_property(@src.hyper::siglum, 'kbrunkhorst-93')
    end
    
    # Test the publishing date
    def test_pubdate
      assert_property(@src.dcns::date, "2007-11-28")
    end
    
    # Test the publisher
    def test_publisher
      assert_property(@src.dcns::publisher, "HyperNietzsche")
    end

    # Test if the curator was imported correctly
    def test_author
      assert_property(@src.dcns::creator, N::LOCAL::kbrunkhorst)
    end
    
    # Test if the data file was imported
    def test_data
      assert_equal(1, @src.data_records.size)
      assert_kind_of(TaliaCore::DataTypes::XmlData, @src.data_records[0])
    end
    
    # Test if the doucument data is valid XML
    def test_data_integrity
      xdoc = REXML::Document.new(@src.data_records[0].content_string)
      assert_equal("TEI", xdoc.root.name)
    end
   
    # And now: already_published
    def test_already_published
      assert_property(@src.hyper::already_published, "no")
    end
    
    def test_manifestation
      assert_property(@src.hyper::manifestation_of, N::LOCAL + 'GD-Sokrates-2')
    end
    
  end
end

