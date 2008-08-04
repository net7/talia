require File.dirname(__FILE__) + '/../../test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  # TODO: DRY tests. Check why login_as :admin doesn't work if inside #setup.
  
  def test_should_get_index
    login_as :admin
    
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  def test_should_get_new
    login_as :admin

    get :new
    assert_response :success
  end
  
  def test_should_create_user
    login_as :admin

    assert_difference('User.count') do
      post :create, :user => params
    end

    assert_redirected_to :action => "show", :id => assigns(:user)
  end
  
  def test_should_show_user
    login_as :admin
    
    get :show, :id => users(:quentin).id
    assert_response :success
  end
  
  def test_should_get_edit
    login_as :admin
    
    get :edit, :id => users(:quentin).id
    assert_response :success
  end
  
  def test_should_update_user
    login_as :admin
    
    put :update, :id => users(:someone).id, :user => params
    assert_redirected_to :action => "show", :id => assigns(:user)
  end
  
  def test_should_destroy_user
    login_as :admin
    
    assert_difference('User.count', -1) do
      delete :destroy, :id => Fixtures.identify(:someone)
    end

    assert_redirected_to :action => "index"
  end
  
  private
    def params
      { :login => 'luca', :email => 'luca@talia.org',
        :password => 'luca', :password_confirmation => 'luca' }
    end
end
