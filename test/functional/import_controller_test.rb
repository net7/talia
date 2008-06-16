require File.dirname(__FILE__) + '/../test_helper'

class ImportControllerTest < ActionController::TestCase
  def test_should_create_manuscript
    post :create, :document => document('Mp-XIV-2')
    assert_response :created    
    assert_kind_of TaliaCore::Source, assigns(:document)
  end
  
  def test_should_return_client_error_on_nil_document
    post :create, :document => nil
    assert_response 400
  end
  
  def test_should_return_client_error_on_empty_document
    post :create, :document => ''
    assert_response 400
  end
  
  def test_should_return_client_error_on_malformed_document
    post :create, :document => '<book'
    assert_response 400
  end
  
  protected
    def document(name)
      File.open(File.join(documents_root, name + '.xml'))
    end
    
    def documents_root
      @documents_root ||= begin
        File.join(File.expand_path(RAILS_ROOT),
        'vendor', 'plugins', 'talia_core',
        'test', 'talia_util', 'import_samples')
      end
    end
end
