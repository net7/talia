require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class CriticalEditionTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    suppress_fixtures
    
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
      setup_once(:ce_one) { create_edition('ce_one') }
      setup_once(:full_edition) do
        edition = create_edition('ce_full')
        2.times do |n|
          book = make_big_book_with_text_reconstructions("ce_test_book#{n}")
          clone_book = edition.add_from_concordant(book, true)
          clone_book.save!
          clone_book
        end
        edition.save!
        edition
      end
    end
    
    
    def test_has_books
      assert_equal(2, @full_edition.books.size)
    end
    
    def test_can_create_html_description
      @full_edition.create_html_description!('test/fixtures/editions_test_data/critical_edition_description.html')
      assert_not_nil(@full_edition.material_description.html)
    end
    
    protected
    
    def create_edition(name)
      CriticalEdition.new('http://www.critical.org/edition/' + name)
    end
    
  end
end

    