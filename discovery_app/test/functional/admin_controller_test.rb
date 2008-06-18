require File.dirname(__FILE__) + '/../test_helper'

class AdminControllerTest < ActionController::TestCase
  def test_should_redirect_to_login_when_not_loggedin
    get :index
    assert_redirected_to login_path
  end

  def test_should_get_index_when_loggedin_as_admin
    login_as :admin
    
    get :index
    assert_response :success
  end
end
