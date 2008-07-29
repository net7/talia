require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class PageTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    def test_manifestation
      page = make_dummy_page('test_manifestation')
      facs = Facsimile.new('manifest-of-test_manifestation')
      page.add_manifestation(facs)
      page.save!
      assert_equal(1, page.manifestations.size)
      assert_equal(facs, page.manifestations[0])
    end
    
    protected
    
    def make_dummy_page(name)
      page = Page.new(name)
      page.save!
      page
    end
    
  end
end
