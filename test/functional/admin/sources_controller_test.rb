require File.dirname(__FILE__) + '/../../test_helper'

class Admin::SourcesControllerTest < ActionController::TestCase
  def setup
    @controller = Admin::SourcesControllerTest.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    # TODO why @id it isn't loaded?
    @id = "http://www.talia.discovery-project.org/sources/something"
  end
  
  def test_should_get_index
    login_as :admin
    get :index
    assert_response :success
    assert_not_nil assigns(:sources)
  end

  def test_should_get_edit
    login_as :admin
    get :edit, :id => "http://www.talia.discovery-project.org/sources/something"
    assert_response :success
  end

  def test_should_update_source
    login_as :admin
    put :update, :id => "http://www.talia.discovery-project.org/sources/something", :source => { }
    assert_redirected_to :action => 'index'
  end
end
