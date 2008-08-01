require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class FacsimileEditionTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    suppress_fixtures
    
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
      setup_once(:fe_one) { create_edition('fe_one') }
      setup_once(:full_edition) do
        edition = create_edition('fe_full')
        (1..3).each do |n|
          book = make_book("fe_test_book#{n}", 4)
          clone_book = edition.add_from_concordant(book, true)
          clone_book.save!
        end
        edition.save!
        edition
      end
    end
    
    def test_books
      assert_equal(3, @full_edition.books.size)
    end
    
    def test_pages
      assert_equal(12, @full_edition.elements(N::TALIA.Page).size)
    end
    
    def test_can_create
      assert_not_nil(@fe_one)
    end
    
    
    protected
    
    def create_edition(name)
      FacsimileEdition.new('http://www.facsimile.org/edition/' + name)
    end
    
  end
end
