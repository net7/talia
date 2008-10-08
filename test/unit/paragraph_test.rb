require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class ParagraphTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
      
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
    end
    
    def test_can_create 
      assert_not_nil(chapter = make_chapter('test_can_create'))
      assert(Source.exists?(chapter.uri))
    end
    
    def test_has_chapter
      book = make_big_book('test_has_chapter')
      paragraph = book.paragraphs[0]
      assert_not_nil(chapter = paragraph.chapter)
      assert(Source.exists?(chapter.uri))
      assert_equal(chapter, book.chapters[0])
    end
    
    def test_has_book
      book = make_big_book('test_has_book')
      paragraph = book.paragraphs[0]
      assert_equal(book, paragraph.book)
    end
    
    def test_has_page
      book = make_big_book('test_has_page')
      paragraph = book.paragraphs[0]
      book_first_page = book.pages[0]
      assert_not_nil(par_page = paragraph.pages[0])
      assert(Source.exists?(par_page))
      assert_equal(par_page, book_first_page)
    end
    
    def test_position_in_book
      book = make_big_book('test_position_in_book')
      paragraph = book.paragraphs[0]
      assert_equal('000000000001', paragraph.position_in_book)
    end
  end
end
    