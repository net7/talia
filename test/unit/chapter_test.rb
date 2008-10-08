require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class ChapterTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    test_cloning N::RDF.type, N::DCNS.title, N::HYPER.position, N::HYPER.name
    
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

    def test_has_ordered_pages
      book = make_big_book('test_has_ordered_pages')
      book.order_pages!
      chapter = book.chapters[0]
      chapter.order_pages!  
      assert_equal(3, chapter.ordered_pages.elements.size)
    end
    
    def test_has_first_page
      book = make_big_book('test_has_first_page')
      chapter = book.chapters[0]
      assert(Source.exists?(chapter.first_page))
      assert_equal(Page, chapter.first_page.class)
    end

    def test_has_subparts_with_manifestations
      book = make_big_book_with_editions('test_has_subparts_with_manifestations')
      book.order_pages!
      chapter = book.chapters[0]
      chapter.order_pages!
      assert_equal(7, chapter.subparts_with_manifestations(N::HYPER.HyperEdition).size)
    end

  end
end