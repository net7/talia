require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class BookTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    test_cloning N::HYPER.position, N::DCNS.description,
      N::DCNS.date, N::DCNS.publisher, N::HYPER.publication_place, 
      N::DCNS.rights, N::HYPER.siglum
    
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
    end
    
    def test_can_create
      assert_not_nil(book = make_book('test_can_create'))
      assert(Source.exists?(book.uri))
    end
    
    def test_has_pages
      book =  make_book('test_has_pages', 4)
      assert_equal(4, book.pages.size)
    end
    
    def test_clone_book
      book = make_book('test_for_clone', 4)
      ordered = book.ordered_pages
      book.pages.each { |p| ordered.add(p) }
      ordered.save!
      catalog = make_catalog('test_cat_for_clone')
      clone = book.clone_to(catalog)
      assert_equal(4, clone.pages.size)
      assert_equal(4, clone.ordered_pages.elements.size)
    end
    
    def test_has_ordered_pages
      book = make_big_book('test_has_ordered_pages')
      book.order_pages!
      assert_equal(5, book.ordered_pages.elements.size)
    end
    
    def test_has_chapters
      book = make_big_book('test_has_chapters')
      assert_equal(2, book.chapters.size)
    end
    
    def test_has_paragraphs
      book = make_big_book('test_has_paragraphs')
      assert_equal(7, book.paragraphs.size)
    end
    
    def test_has_subparts
      book = make_big_book('test_has_subparts')
      assert_equal(12, book.subparts.size)
    end
  
    def test_has_subparts_with_manifestations
      book = make_big_book_with_text_reconstructions('test_has_subparts_with_manifestations')
      assert_equal(12, book.subparts_with_manifestations(N::HYPER.HyperEdition).size)
    end
    
    def test_has_pages_with_manifestations
      book = make_big_book_with_text_reconstructions('test_has_pages_with_manifestations')
      assert_equal(5, book.subparts_with_manifestations(N::HYPER.HyperEdition, N::HYPER.Page).size)
    end

    def test_has_paragraphs_with_manifestations
      book = make_big_book_with_text_reconstructions('test_has_paragraphs_with_manifestations')
      assert_equal(7, book.subparts_with_manifestations(N::HYPER.HyperEdition, N::HYPER.Paragraph).size)
    end

  end
end