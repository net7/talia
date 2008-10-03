require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class BookTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    test_cloning N::RDF.type, N::HYPER.position, N::DCNS.description,
      N::DCNS.date, N::DCNS.publisher, N::HYPER.publication_place, 
      N::HYPER.copyright_note, N::HYPER.siglum
    
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
    
#    def test_has_type
#      book =  make_book('test_type')
#      assert_not_nil(book.type)
#    end
#    
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
    
    def test_has_material_description
      book = make_book('test_material_description')
      description = Source.new('desc-of_test_material_description')
      description.predicate_set(:hyper, :material_description, book)
      description.save!
      assert_equal(book.material_description, description)
    end
    
  end
end