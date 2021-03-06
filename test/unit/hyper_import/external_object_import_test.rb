require 'test/unit'
require 'rexml/document'


# Load the helper class
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class ExternalObjectImportTest < Test::Unit::TestCase
  
    include UtilTestMethods
    
    suppress_fixtures
    
    # Flush RDF before each test
    def setup
      flush_once_for_import_test
      setup_once(:src) { hyper_import(load_doc('mmontinari-nmgii-1988')) }
      setup_once(:in_journal) { hyper_import(load_doc('mmontinari-zvlbn-1987')) }
      setup_once(:has_pages) { hyper_import(load_doc('hjmette-dhnfn-1932')) }
      setup_once(:with_xml_entity) { hyper_import(load_doc('tandina-aodns-2001')) }
    end
    
    # Test if the import succeeds
    def test_import
      assert_kind_of(TaliaCore::ExternalObject, @src)
    end
    
    # Test if the types were imported correctly
    def test_types
      assert_types(@src, N::HYPER.ExternalObject)
    end
    
    # Test the title property
    def test_title
      assert_property(@src.dcns::title, "Nietzsche mit Goethe in Italien")
    end
    
    # Test source name
    def test_urig
      assert_equal(N::LOCAL + "mmontinari-nmgii-1988", @src.uri)
    end
    
    def test_siglum
      assert_property(@src.hyper::siglum, 'mmontinari-nmgii-1988')
    end
    
    # Test the publishing date
    def test_pubdate
      assert_property(@src.dcns::date, "1988-01-01")
    end
    
    # Test the publisher
    def test_publisher
      assert_property(@src.dcns::publisher, "Apollo : studi e testi de germanistica e di comparatistica ; 2")
    end

    # Test if the curator was imported correctly
    def test_author
      assert_property(@src.dcns::creator, N::LOCAL::mmontinari)
    end

    # And now: already_published
    def test_already_published
      assert_property(@src.hyper::already_published, "no")
    end
    
    # Test the language setting
    def test_language
      assert_property(@src.dcns::language, "de")
    end
    
    def test_publisher
      assert_property(@src.dcns::publisher, 'Apollo : studi e testi de germanistica e di comparatistica ; 2')
    end
    
    def test_publishing_place
      assert_property(@src.hyper::publication_place, 'Gardolo di Trento')
    end
    
    def test_first_page
      assert_property(@src.hyper::first_page, '303')
    end
    
    def test_last_page
      assert_property(@src.hyper::last_page, '317')
    end
    
    def test_in_journal
      assert_property(@in_journal.hyper::journal_information, 'Editio. Internationales Jahrbuch für Editionswissenschaft, Bd. 1')
    end
    
    def test_in_book
      assert_property(@src.hyper::collection_information, "Italienische Reise - Reisen nach Italien / hrsg. v. Italo Michele Battafarano")
    end
    
    def test_pages
      assert_property(@has_pages.hyper::pages_information, 'IV, 86')
    end
    
    def test_related_contribution
      assert_property(@src.hyper::related_contribution, N::LOCAL + "mmontinari-3")
    end
    
    def test_xml_entity_decoding
      assert_property(@with_xml_entity.dcns::publisher, 'Rosenberg & Selier')
    end
  end
end
