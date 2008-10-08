require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class PageTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    test_cloning N::DCNS.title, 
      N::HYPER.position, N::HYPER.position_name, 
      N::HYPER.height, N::HYPER.width,
      N::HYPER.dimension_units,
      N::HYPER.siglum, 
      N::RDF.type 
    
    def test_can_create
      assert_not_nil(page = make_page('test_can_create'))
      assert(Source.exists?(page.uri))
    end
    
    def test_has_book
      book = make_big_book('test_has_book')
      page = book.pages[0]
      assert_equal(book, page.book)      
      assert_equal(Book, page.book.class)
    end

    def test_has_chapter
      book = make_big_book('test_has_chapter')
      page = book.pages[0]
      chapter = book.chapters[0]
      assert_equal(chapter, page.chapter)      
      assert_equal(Chapter, page.chapter.class)
      assert_equal('000001', page.position_in_chapter)
    end
    
    
    def test_neighbour_pages
      book = make_big_book('test_neighbour_pages')
      book.order_pages!
      page = book.pages[1]
      assert(Source.exists?(page.next_page))
      assert(Source.exists?(page.previous_page))
    end
    
    def test_has_subparts
      book = make_big_book('test_has_subparts')
      book.order_pages!
      page = book.pages[0]
      assert(Source.exists?(page.notes[0]))
      assert_equal(Note, page.notes[0].class)
      assert(Source.exists?(page.paragraphs[0]))
      assert_equal(Paragraph, page.paragraphs[0].class)
    end
  end
end
