require 'test/unit'
require 'rexml/document'


# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class EssayImportTest < Test::Unit::TestCase
  
    include UtilTestMethods
    
    # Flush RDF before each test
    def setup
      setup_once(:flush) do
        clean_data_files
        TaliaCore::TestHelper.flush_rdf
        TaliaCore::TestHelper.flush_db
      end
      setup_once(:src) do
        hyper_import(load_doc('jgrzelczyk-4'))
      end
      setup_once(:with_abstract) do
        hyper_import(load_doc('rmullerbuck-1'))
      end
    end
    
    # Test if the import succeeds
    def test_import
      assert_kind_of(TaliaCore::Source, @src)
    end
    
    # Test if the types were imported correctly
    def test_types
      assert_types(@src, N::HYPER + "Essay", N::HYPER + "PDF")
    end
    
    # Test the title property
    def test_title
      assert_property(@src.dcns::title, "Féré et Nietzsche : au sujet de la décadence")
    end
    
    # Test source name
    def test_siglum
      assert_equal(N::LOCAL + "jgrzelczyk-4", @src.uri)
    end
    
    # Test the publishing date
    def test_pubdate
      assert_property(@src.dcns::date, "2005-11-01")
    end
    
    # Test the publisher
    def test_publisher
      assert_property(@src.dcns::publisher, "HyperNietzsche")
    end

    # Test if the curator was imported correctly
    def test_author
      assert_property(@src.hyper::author, N::LOCAL::jgrzelczyk)
    end

    # And now: already_published
    def test_already_published
      assert_property(@src.hyper::already_published, "yes")
    end
    
    # Test the language setting
    def test_language
      assert_property(@src.dcns::language, "fr")
    end
    
    def test_abstract
      assert_property(@with_abstract.hyper::abstract, 'Chronologisch lassen sich drei Phasen der Annäherung Nietzsches an Frankreich unterscheiden: Die erste Phase beginnt im Herbst 1876 in Sorrent, nach dem Bruch mit Wagner. Diese erste intensive Hinwendung zu Frankreich geht mit der Abwendung von Wagner einher. Die zweite, weitaus wichtigere Phase, die im Winter 1883/84 während seines ersten Aufenthalts in Nizza beginnt, steht im Zeichen Paul Bourgets und der Psychologie. Erst in Frankreich wird Nietzsche zum Psychologen. Die dritte und letzte Phase, gewissermaßen der Gipfel- und Kulminationspunkt seiner Hinwendung zu Frankreich, ist in das Jahr 1888 zu datieren. In ihr taucht er zuletzt völlig in die französische Kultur ein, allerdings nicht gegen, sondern mit Richard Wagner.')
    end
    
  end
end
