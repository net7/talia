require 'test/unit'
require 'rexml/document'


# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class EditionImportTest < Test::Unit::TestCase
  
    # Establish the database connection for the test
    TaliaCore::TestHelper.startup
    
    
    # Flush RDF before each test
    def setup
      unless(@src)
        TaliaCore::TestHelper.flush_rdf
        TaliaCore::TestHelper.flush_db
      end
      @src = HyperImporter::Importer.import(UtilHelper.load_doc('edition'))
    end
    
    # Test if the import succeeds
    def test_import
      assert_kind_of(TaliaCore::Source, @src)
    end
    
    # Test if the types were imported correctly
    def test_types
      assert_equal(1, @src.types.size)
      assert_equal(N::HYPER + "Edition", @src.types[0])
    end
    
    # Test the title property
    def test_title
      assert_equal(1, @src.dcns::title.size)
      assert_equal("edition", @src.dcns::title[0])
    end
    
    # Test source name
    def test_siglum
      assert_equal(N::LOCAL + "kbrunkhorst-93", @src.uri)
    end
    
    # Test the publishing date
    def test_pubdate
      assert_equal(1, @src.dcns::date.size)
      assert_equal("2007-11-28", @src.dcns::date[0])
    end
    
    # Test the publisher
    def test_publisher
      assert_equal(1, @src.dcns::publisher.size)
      assert_equal("HyperNietzsche", @src.dcns::publisher[0])
    end

    # Test if the curator was imported correctly
    def test_curator
      assert_equal(1, @src.hyper::curator.size)
      assert_kind_of(TaliaCore::Source, @src.hyper::curator[0])
      assert_equal(N::LOCAL::kbrunkhorst, @src.hyper::curator[0].uri)
    end
    
    # Test if the data file was imported
    def test_data
      assert_equal(1, @src.data_records.size)
      assert_kind_of(TaliaCore::XmlData, @src.data_records[0])
    end
    
    # Test if the doucument data is valid XML
    def test_data_integrity
      xdoc = REXML::Document.new(@src.data_records[0].content_string)
      assert_equal("TEI", xdoc.root.name)
    end
   
    # And now: already_published
    def test_already_published
      assert_equal(1, @src.hyper::already_published.size)
      assert_equal("no", @src.hyper::already_published[0])
    end
    
  end
end

