require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class CategoryTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    def setup
      setup_once(:init) do
        TaliaUtil::Util.flush_rdf
        TaliaUtil::Util.flush_db
        true
      end
    end
    
    def test_members
      cat = make_category('test_members')
      card1 = make_card('test_members_1')
      card2 = make_card('test_members_2')
      card1.category = cat
      card2.category = cat
      card1.save!
      card2.save!
      assert_equal([card1, card2], cat.members)
    end
    
    private
    
    def make_category(name)
      make_card(name, true, Category)
    end
    
  end
end
