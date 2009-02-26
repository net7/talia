require File.dirname(__FILE__) + '/../unit_test_helpers'

require 'test/unit'
require 'rexml/document'
require 'fileutils'

# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test the DataRecord storage class
  class FacsimileImportTest < Test::Unit::TestCase
  
    include UtilTestMethods
    include TaliaCore::UnitTestHelpers
    
    suppress_fixtures
    
    # Flush RDF before each test
    def setup
      flush_once_for_import_test
      setup_once(:setup_iip) do
        setup_iip
        true
      end
      setup_once(:src) { hyper_import(load_doc('egrepalysviola-3259')) }
    end
    
    def teardown
      clean_iip
    end
    
    # Test if the import succeeds
    def test_import
      assert_kind_of(TaliaCore::Facsimile, @src)
    end
    
    # Test if the types were imported correctly
    def test_types
      assert_types(@src, N::HYPER + "Facsimile", N::HYPER + "Color")
    end
    
    # Test the title property
    def test_title
      assert_property(@src.dcns::title)
    end
    
    # Test source name
    def test_uri
      assert_equal(N::LOCAL + "egrepalysviola-3259", @src.uri)
    end
    
    def test_siglum
      assert_property(@src.hyper::siglum, 'egrepalysviola-3259')
    end
    
    # Test the publishing date
    def test_pubdate
      assert_property(@src.dcns::date, "2003-06-24")
    end
    
    # Test the publisher
    def test_publisher
      assert_property(@src.dcns::publisher, "HyperNietzsche")
    end

    # Test if the curator was imported correctly
    def test_author
      assert_property(@src.dcns::creator, N::LOCAL::sviola, N::LOCAL::egrepaly)
    end
    
    # Test if the data file was imported
    def test_data
      assert_equal(2, @src.data_records.size)
    end

    def test_iip_record
      iip_recs = @src.data_records.find(:all, :conditions => { :type => 'IipData' })
      assert_equal(1, iip_recs.size)
      assert_kind_of(TaliaCore::DataTypes::IipData, iip_recs[0])
      assert_equal('N-V-4,97.jpeg', iip_recs[0].location)
    end

    def test_image_record
      image_recs = @src.data_records.find(:all, :conditions => { :type => 'ImageData' })
      assert_equal(1, image_recs.size)
      assert_kind_of(TaliaCore::DataTypes::ImageData, image_recs[0])
      assert_equal('N-V-4,97.jpeg', image_recs[0].location)
    end
   
    def test_manifestation_of
      assert_property(@src.hyper::manifestation_of, N::LOCAL + 'N-V-4,97')
    end
    
    # And now: already_published
    def test_already_published
      assert_property(@src.hyper::already_published, "no")
    end
    
    # Test import of the dimensions
    def test_dimensions
      assert_property(@src.dct::extent, "2556x3988 pixel")
      assert_equal(@src.dimensions, "2556x3988 pixel")
    end

    def test_blank
      blank_facs = hyper_import(load_doc('egrepalysviola-blank'))
      assert(blank_facs.blank == 'true')
    end
    
  end
end
