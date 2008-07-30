require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class PageTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    def test_true
      assert(true)
    end
    
    protected
    
    def make_dummy_page(name)
      page = Page.new(name)
      page.save!
      page
    end
    
  end
end
