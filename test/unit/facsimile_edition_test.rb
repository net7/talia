require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class FacsimileEditionTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    def test_can_create
      create_dummy_edition
      assert_not_nil(@fe)
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
