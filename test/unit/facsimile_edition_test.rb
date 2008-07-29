require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class FacsimileEditionTest < Test::Unit::TestCase
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
      create_dummy_edition
      assert_not_nil(@fe)
    end
    
    def test_has_books
      create_dummy_edition
      assert_equal(2, @fe.books.size)
    end
    
    protected
    
    def create_dummy_edition
      @fe = FacsimileEdition.new('http://www.facsimile.org/edition')
      (1..3).each do |n|
        book = create_dummy_book("#{book}-#{n}")
        book.pages.each do |page|
          page.manifestations { |man| @fe.add(man) if(man.is_a?(Facsimile)) }
        end
      end
    end
    
  end
end
