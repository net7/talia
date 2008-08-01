require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class BookTest < Test::Unit::TestCase
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
      assert_not_nil(book = make_book('test_can_create'))
      assert(Source.exists?(book.uri))
    end
    
    def test_has_pages
      book =  make_book('test_has_pages', 4)
      assert_equal(4, book.pages.size)
    end
    
    def test_has_material_description
      book = make_book('test_material_description')
      description = Source.new('desc-of_test_material_description')
      description.predicate_set(:hyper, :description_of, book)
      description.save!
      assert_equal(book.material_description, description)
    end
    
  end
end