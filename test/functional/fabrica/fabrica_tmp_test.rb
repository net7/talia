require File.dirname(__FILE__) + '/../fabrica_test_helper'

class FabricaTmpTest < Test::Unit::TestCase
  
  def setup
    @controller = ImportController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    setup_once(:src) { source_import('export1', 'D-10a,1')}
  end
  
  def test_types
      assert_types(@src, N::HYPER + "Manuscript", N::HYPER + "Page")
  end
end
