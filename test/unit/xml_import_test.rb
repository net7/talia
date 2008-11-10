require 'test/unit'
require 'rexml/document'

# Load the helper class
require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaUtil

  # Test te DataRecord storage class
  class XmlImportTest < Test::Unit::TestCase

    # Flush RDF before each test
    def setup
      setup_once(:flush) do
        Util.flush_rdf
        Util.flush_db
        true
      end
    end
     
    def test_import_book_with_catalog
      assert_difference "TaliaCore::Book.count", 2 do
        XmlImport::import(get_path('KGW-AC.xml'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW-AC'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW/KGW-AC'))
        cloned_book = TaliaCore::Book.find(N::LOCAL + 'KGW/KGW-AC')
        original_book = TaliaCore::Book.find(N::LOCAL + 'KGW-AC')
        assert_equal(N::LOCAL + 'KGW', cloned_book.catalog.uri)
        assert_equal(cloned_book, original_book.concordant_cards(N::LOCAL + 'KGW')[0])
      end
    end
    
    
    def test_import_page_with_catalog
      assert_difference "TaliaCore::Page.count", 2 do
        XmlImport::import(get_path('KGW-AC,[Text].xml'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW-AC,[Text]'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW/KGW-AC,[Text]'))
        cloned_page = TaliaCore::Page.find(N::LOCAL + 'KGW/KGW-AC,[Text]')
        original_page = TaliaCore::Page.find(N::LOCAL + 'KGW-AC,[Text]')
        assert_equal('000001', cloned_page.position)
        assert_equal(N::LOCAL + 'KGW/KGW-AC', cloned_page.book.uri)
        assert_equal(N::LOCAL + 'KGW', cloned_page.catalog.uri)
        assert_equal(cloned_page, original_page.concordant_cards(N::LOCAL + 'KGW')[0])
      end
    end

    def test_import_chapter_with_catalog
      assert_difference "TaliaCore::Chapter.count", 2 do
        XmlImport::import(get_path('KGW-AC-[Text].xml'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW-AC-[Text]'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW/KGW-AC-[Text]'))
        cloned_chapter = TaliaCore::Chapter.find(N::LOCAL + 'KGW/KGW-AC-[Text]')
        original_chapter = TaliaCore::Chapter.find(N::LOCAL + 'KGW-AC-[Text]')
        assert_equal(N::LOCAL + 'KGW/KGW-AC,[Text]', cloned_chapter.first_page.uri)
        assert_equal(N::LOCAL + 'KGW/KGW-AC', cloned_chapter.book.uri)
        assert_equal(cloned_chapter, original_chapter.concordant_cards(N::LOCAL + 'KGW')[0])
      end
    end
 
    def test_import_paragraph_with_catalog
      assert_difference "TaliaCore::Paragraph.count", 2 do
        XmlImport::import(get_path('KGW-AC-17.xml'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW-AC-17'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW/KGW-AC-17'))
        cloned_paragraph = TaliaCore::Paragraph.find(N::LOCAL + 'KGW/KGW-AC-17')
        original_paragraph = TaliaCore::Paragraph.find(N::LOCAL + 'KGW-AC-17')

        cloned_note = TaliaCore::Note.find(N::LOCAL + 'KGW/KGW-AC-17-note17')
        original_note = TaliaCore::Note.find(N::LOCAL + 'KGW-AC-17-note17')
        assert_equal(N::LOCAL + 'KGW/KGW-AC-17', cloned_paragraph.uri)
        assert_equal(N::LOCAL + 'KGW/KGW-AC-17-note17', cloned_paragraph.notes[0].uri)
        assert_equal(N::LOCAL + 'KGW/KGW-AC,[Text]', cloned_paragraph.pages[0].uri)
        assert_equal(N::LOCAL + 'KGW', cloned_paragraph.catalog.uri)
        assert_equal(cloned_paragraph, original_paragraph.concordant_cards(N::LOCAL + 'KGW')[0])
        assert_equal(cloned_note, original_note.concordant_cards(N::LOCAL + 'KGW')[0])
      end
    end
    
    def test_import_facsimile
      assert_difference "TaliaCore::Facsimile.count", 1 do
        XmlImport::import(get_path('egrepalysviola-1.xml'))
        assit(TaliaCore::Source.exists?(N::LOCAL + 'egrepalysviola-1'))
        fax = TaliaCore::Facsimile.find(N::LOCAL + 'egrepalysviola-1')
        assert_equal(N::LOCAL + 'AC,[Text]', fax::hyper.manifestation_of)
      end
    end
    
    def test_import_text_reconstruction_with_catalog
      XmlImport::import(get_path('kbrunkhorst-93.xml'))
      XmlImport::import(get_path('KGW-AC-17.xml'))
      assit(TaliaCore::Source.exists?(N::LOCAL + 'kbrunkhorst-93'))
      assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW-AC-17'))
      assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW/KGW-AC-17'))
      tr = TaliaCore::TextReconstruction.find(N::LOCAL + 'kbrunkhorst-93')
      original_page = (TaliaCore::Paragraph.find(N::LOCAL + 'KGW-AC-17'))
      cloned_page = (TaliaCore::Paragraph.find(N::LOCAL + 'KGW/KGW-AC-17'))
      assert_equal(tr.uri.too_s, original_page.inverse[N::HYPER.manifestation_of])
      assert_equal(tr.uri.too_s, cloned_page.inverse[N::HYPER.manifestation_of])
  
    end
    #TODO: to be reintroduced after the review
    #    def test_import_multiple_clone_pages
    #      assert_difference "TaliaCore::Page.count", 4 do
    #        XmlImport::import(get_path('KGW-AC,[Text].xml'))
    #        XmlImport::import(get_path('KGW-AC,[Text].xml'))
    #        XmlImport::import(get_path('GED-AC,[Text].xml'))
    #        XmlImport::import(get_path('KGW-AC.xml'))
    #        assert(TaliaCore::Source.exists?(N::LOCAL + 'KGW-AC'))
    #        assert(TaliaCore::Source.exists?(N::LOCAL + 'KGW-AC,[Text]'))
    #        book = TaliaCore::Book.find(N::LOCAL + 'KGW-AC')
    #        page = TaliaCore::Page.find(N::LOCAL + 'KGW-AC,[Text]')
    #        assert_equal(1, book.ordered_pages.elements.size)
    #        assert_equal(page, book.ordered_pages.first)
    #        fe_uri = 'http://www.facsimile.org/edition/test'
    #        fe = TaliaCore::FacsimileEdition.new(fe_uri)
    #        fe.add_from_concordant(book, true)
    #        assert(TaliaCore::FacsimileEdition.exists?(fe_uri))
    #        assert_equal(1, fe.elements_by_type(N::TALIA.Page).size)
    #      end
    #    end
    
    #TODO: to be reintroduced after the review
    #    def test_import_pages
    #       assert_difference "TaliaCore::Page.count", 2 do
    #        XmlImport::import(get_path('KGW-AC,[Text].xml'))
    #        XmlImport::import(get_path('KGW-AC,1.xml'))
    #        XmlImport::import(get_path('KGW-AC.xml'))
    #        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW-AC'))
    #        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW-AC,[Text]'))
    #        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW-AC,1'))
    #        page1 = TaliaCore::Page.find(N::LOCAL + 'KGW-AC,[Text]')
    #        page2 = TaliaCore::Page.find(N::LOCAL + 'KGW-AC,1')
    #        assert_equal(N::LOCAL + 'KGW-AC', page1.book.uri)
    #        assert_equal(N::LOCAL + 'KGW-AC', page2.book.uri)
    #        book = TaliaCore::Book.find(N::LOCAL + 'KGW-AC')
    #        assert_equal(2, book.ordered_pages.elements.size)
    #        assert_equal(page1, book.ordered_pages.first)
    #      end
    #    end
    
    #TODO:after the review
    #    def test_import_page_twice
    #      assert_difference "TaliaCore::Page.count", 3 do
    #        XmlImport::import(get_path('KGW-AC,[Text].xml'))
    #        XmlImport::import(get_path('GED-AC,[Text].xml'))
    #        assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW-AC,[Text]'))
    #        page = TaliaCore::Page.find(N::LOCAL + 'KGW-AC,[Text]')
    #        assert_equal('000001', page.position)
    #        #        assert_nothing_raised() { |page.position|  }
    #      end
    #    end

    def test_import_multiple_sources
      XmlImport::import(get_path('KGW-AC_multiple.xml'))
      assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW-AC'))
      assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW-AC-17'))
      assit(TaliaCore::Source.exists?(N::LOCAL + 'KGW-AC,[Text]'))
      book = TaliaCore::Book.find(N::LOCAL + 'KGW-AC')
      page = TaliaCore::Page.find(N::LOCAL + 'KGW-AC,[Text]')
      paragraph = TaliaCore::Paragraph.find(N::LOCAL + 'KGW-AC-17')
      assert_equal(paragraph, page.paragraphs[0])
      assert_equal(book, page.book)
      assert_equal(page, paragraph.pages[0])
      assert_equal(page, book.pages[0])
    end
    
    private 
      
    def get_path(filename)
      fullpath = File.expand_path(File.dirname(__FILE__)) + '/../fixtures/xml_import_samples/' + filename
      fullpath
    end
      
      
      
      
  end
end
  