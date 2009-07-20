require 'test/unit'
require 'rexml/document'

# Load the helper class
#require File.dirname(__FILE__) + '/unit_test_helpers'
require File.join(File.dirname(__FILE__), 'util_helper')

# require util stuff
require 'talia_util'

module TaliaUtil

  # Test te DataRecord storage class
  class XmlImportTest < Test::Unit::TestCase
    include UtilTestMethods

    # Flush RDF before each test
    def setup
      setup_once(:flush) do
        flush_dbs
        flush_once_for_import_test
        true
      end
    end

    def teardown
      flush_dbs
      true
    end

    def flush_dbs
      Util.flush_rdf
      Util.flush_db
    end

    def test_dummy
      assert(true)
    end

    
    def test_import_book_with_catalog
      assert_difference "TaliaCore::Book.count", 1 do
        XmlImport::import(get_path('KGW-A.xml'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW/A'))
        book = TaliaCore::Book.find(N::LOCAL + 'KGW/A')
        assert_equal(N::LOCAL + 'KGW', book.catalog.uri)
      end
    end
    
    
    def test_import_page_with_catalog
      assert_difference "TaliaCore::Page.count", 1 do
        XmlImport::import(get_path('KGW-B,[Text].xml'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW/B,[Text]'))
        page = TaliaCore::Page.find(N::LOCAL + 'KGW/B,[Text]')
        assert_equal('000001', page.position)
        assert_equal(N::LOCAL + 'KGW/B', page.book.uri)
        #        assert_equal(N::LOCAL + 'KGW', page.catalog.uri)
      end
    end
    
    def test_import_chapter_with_catalog
      assert_difference "TaliaCore::Chapter.count", 1 do
        XmlImport::import(get_path('KGW-C-[Text].xml'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW/C-[Text]'))
        chapter = TaliaCore::Chapter.find(N::LOCAL + 'KGW/C-[Text]')
        assert_equal(N::LOCAL + 'KGW/C,[Text]', chapter.first_page.uri)
        assert_equal(N::LOCAL + 'KGW/C', chapter.book.uri)
      end
    end
    
    def test_import_paragraph_with_catalog
      assert_difference "TaliaCore::Paragraph.count", 1 do
        XmlImport::import(get_path('KGW-D-17.xml'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW/D-17'))
        paragraph = TaliaCore::Paragraph.find(N::LOCAL + 'KGW/D-17')
        note = TaliaCore::Note.find(N::LOCAL + 'KGW/D,[Text]-note17')
        assert_equal(N::LOCAL + 'KGW/D-17', paragraph.uri)
        assert_equal(N::LOCAL + 'KGW/D,[Text]-note17', paragraph.notes[0].uri)
        assert_equal(N::LOCAL + 'KGW/D,[Text]', paragraph.pages[0].uri)
      end
    end
    
    
    def test_import_paragraph_with_catalog_2
      assert_difference "TaliaCore::Paragraph.count", 1 do
        XmlImport::import(get_path('BFE-para-2.xml'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'BFE/Ms-139a,2r[3]et2v[1]'))
        paragraph = TaliaCore::Paragraph.find(N::LOCAL + 'BFE/Ms-139a,2r[3]et2v[1]')
        note1 = TaliaCore::Note.find(N::LOCAL + 'BFE/Ms-139a,2r-note3')
        note2 = TaliaCore::Note.find(N::LOCAL + 'BFE/Ms-139a,2v-note1')
        assert_equal(N::LOCAL + 'BFE/Ms-139a,2r[3]et2v[1]', paragraph.uri)
        assert_equal(N::LOCAL + 'BFE/Ms-139a,2r-note3', paragraph.notes[0].uri)
        assert_equal(N::LOCAL + 'BFE/Ms-139a,2v-note1', paragraph.notes[1].uri)
        assert_equal(N::LOCAL + 'BFE/Ms-139a,2r', note1::hyper.page[0].uri)
        assert_equal(N::LOCAL + 'BFE/Ms-139a,2v', note2::hyper.page[0].uri)
      end
    end
    
    def test_import_paragraph_with_catalog_3
      assert_difference "TaliaCore::Paragraph.count", 1 do
        XmlImport::import(get_path('BFE-para.xml'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'BFE/Ms-139a,1r[2]et1v[1]et2r[1]'))
        paragraph = TaliaCore::Paragraph.find(N::LOCAL + 'BFE/Ms-139a,1r[2]et1v[1]et2r[1]')
        note1 = TaliaCore::Note.find(N::LOCAL + 'BFE/Ms-139a,1r-note2')
        note2 = TaliaCore::Note.find(N::LOCAL + 'BFE/Ms-139a,1v-note1')
        note3 = TaliaCore::Note.find(N::LOCAL + 'BFE/Ms-139a,2r-note1')
        assert_equal(N::LOCAL + 'BFE/Ms-139a,1r[2]et1v[1]et2r[1]', paragraph.uri)
        assert_equal(N::LOCAL + 'BFE/Ms-139a,1r-note2', paragraph.notes[0].uri)
        assert_equal(N::LOCAL + 'BFE/Ms-139a,1v-note1', paragraph.notes[1].uri)
        assert_equal(N::LOCAL + 'BFE/Ms-139a,2r-note1', paragraph.notes[2].uri)
        assert_equal(N::LOCAL + 'BFE/Ms-139a,1r', note1::hyper.page[0].uri)
        assert_equal(N::LOCAL + 'BFE/Ms-139a,1v', note2::hyper.page[0].uri)
      end
    end
    
    def test_import_facsimile
      assert_difference "TaliaCore::Facsimile.count", 1 do
        XmlImport::import(get_path('egrepalysviola-1.xml'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'egrepalysviola-1'))
        fax = TaliaCore::Facsimile.find(N::LOCAL + 'egrepalysviola-1')
        assert_equal(N::LOCAL + 'KGW/E,[Text]', fax::hyper.manifestation_of.first.to_s)
      end
    end
    
    
    def test_import_text_reconstruction_with_catalog
      XmlImport::import(get_path('kbrunkhorst-93.xml'))
      XmlImport::import(get_path('KGW-AC-17.xml'))
      assit(TaliaCore::Source.exists?(N::LOCAL + 'kbrunkhorst-93'))
      assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW/AC-17'))
      tr = TaliaCore::TextReconstruction.find(N::LOCAL + 'kbrunkhorst-93')
      page = (TaliaCore::Paragraph.find(N::LOCAL + 'KGW/AC-17'))
      assert_equal(tr, page.inverse[N::HYPER.manifestation_of][0])

    end
    
    def test_import_pages
      assert_difference "TaliaCore::Page.count", 2 do
        XmlImport::import(get_path('KGW-AC,[Text].xml'))
        XmlImport::import(get_path('KGW-AC,1.xml'))
        XmlImport::import(get_path('KGW-AC.xml'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW/AC'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW/AC,[Text]'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW/AC,1'))
        page1 = TaliaCore::Page.find(N::LOCAL + 'KGW/AC,[Text]')
        page2 = TaliaCore::Page.find(N::LOCAL + 'KGW/AC,1')
        assert_equal(N::LOCAL + 'KGW/AC', page1.book.uri)
        assert_equal(N::LOCAL + 'KGW/AC', page2.book.uri)
        book = TaliaCore::Book.find(N::LOCAL + 'KGW/AC')
        book.order_pages!
        assert_equal(2, book.ordered_pages.elements.size)
        assert_equal(page1, book.ordered_pages.first)
      end
      assert_equal(TaliaCore::Page.find(N::LOCAL + 'KGW/AC,1').my_rdf[N::DCNS.title].first, 'AC,1')
    end
       
    private
      
    def get_path(filename)
      fullpath = File.expand_path(File.dirname(__FILE__)) + '/../../fixtures/xml_import_samples/' + filename
      fullpath
    end
      
      
      
      
  end
end
  