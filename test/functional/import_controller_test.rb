require File.dirname(__FILE__) + '/fabrica_test_helper'

class ImportControllerTest < ActionController::TestCase
  
  def test_should_create_manuscript
    authorize_as :hyper
    assert_difference "TaliaCore::Book.count", 1 do
      post :create, :document => document('export')
      assert_response :created
      # TODO restore the following assertion when the test suite will work again.
      # assert_equal "/documents/???", @response[:location]
      assert_kind_of TaliaCore::Source, assigns(:document)  
    end
  end

  def test_import_page_with_catalog
    authorize_as :hyper
    assert_difference "TaliaCore::Page.count", 1 do
      post :create, :document => document('export_KGW-AC,1_page_with_catalog') # imports the D-11,101v page
      assert_response :created
      assert_kind_of TaliaCore::Page, assigns(:document)
     cloned_page = TaliaCore::Page.find(N::LOCAL + 'KGW/AC,1')
    end
  end

  
  def test_import_with_catalog
    authorize_as :hyper
    assert_difference "TaliaCore::Book.count", 2 do
      post :create, :document => document('export_KGW-AC_book_with_catalog')
      assert_response :created
      cloned_book = TaliaCore::Source.find(N::LOCAL + 'KGW/KGW-AC')
      assert(cloned_book.catalog = N::LOCAL + 'KGW')
    end
  end
  
  def test_import_page
    authorize_as :hyper
    assert_difference "TaliaCore::Page.count", 1 do
      post :create, :document => document('export5') # imports the D-11,101v page
      assert_response :created
      assert_kind_of TaliaCore::Page, assigns(:document)
    end
  end
  
  
  def test_should_return_client_error_on_nil_document
    authorize_as :hyper
    assert_no_difference "TaliaCore::Source.count" do
      post :create, :document => nil
      assert_response :unprocessable_entity      
    end
  end
  
  def test_should_return_client_error_on_empty_document
    authorize_as :hyper
    assert_no_difference "TaliaCore::Source.count" do
      post :create, :document => ''
      assert_response :unprocessable_entity      
    end
  end
  
  def test_should_return_client_error_on_malformed_document
    authorize_as :hyper
    assert_no_difference "TaliaCore::Source.count" do
      post :create, :document => 'book'
      assert_response :unprocessable_entity      
    end
  end
  
  def test_should_redirect_to_login_path_on_missing_authorization
    post :create, :document => document('export')
    assert_redirected_to login_path
  end
end
