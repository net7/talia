require File.dirname(__FILE__) + '/unit_test_helpers'

module TaliaCore
  class PageTest < Test::Unit::TestCase
    include TaliaUtil::TestHelpers
    include UnitTestHelpers
    
    test_cloning N::DCNS.title, 
      N::HYPER.position, N::HYPER.position_name, 
      N::HYPER.height, N::HYPER.width,
      N::HYPER.dimension_units,
      N::HYPER.siglum, 
      N::RDF.type 
    
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
