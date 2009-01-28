require File.dirname(__FILE__) + '/../test_helper'

class CategoriesControllerTest < ActionController::TestCase
  def test_index_should_redirect_to_root_url
    get :index
    assert_redirected_to root_url
  end
end
