require File.dirname(__FILE__) + '/fabrica_tester'

class ImportControllerTest < FabricaTester
  
  def test_should_create_manuscript
    authorize_as :hyper
    assert_difference "Source.count", 2 do
      post :create, :document => document('export')
      assert_response :created    
      assert_kind_of Source, assigns(:document)      
    end
  end
  
  def test_should_return_client_error_on_nil_document
    authorize_as :hyper
    assert_no_difference "Source.count" do
      post :create, :document => nil
      assert_response 400      
    end
  end
  
  def test_should_return_client_error_on_empty_document
    authorize_as :hyper
    assert_no_difference "Source.count" do
      post :create, :document => ''
      assert_response 400      
    end
  end
  
  def test_should_return_client_error_on_malformed_document
    authorize_as :hyper
    assert_no_difference "Source.count" do
      post :create, :document => 'book'
      assert_response 400      
    end
  end
  
  def test_should_redirect_to_login_path_on_missing_authorization
    post :create, :document => document('export')
    assert_redirected_to login_path
  end
  
end
