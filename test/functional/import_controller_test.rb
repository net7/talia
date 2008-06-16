require File.dirname(__FILE__) + '/../test_helper'

class ImportControllerTest < ActionController::TestCase
  include TaliaCore
  
  def test_should_create_manuscript
    assert_difference "Source.count", 2 do
      post :create, :document => document('Mp-XIV-2')
      assert_response :created    
      assert_kind_of Source, assigns(:document)      
    end
  end
  
  def test_should_return_client_error_on_nil_document
    assert_no_difference "Source.count" do
      post :create, :document => nil
      assert_response 400      
    end
  end
  
  def test_should_return_client_error_on_empty_document
    assert_no_difference "Source.count" do
      post :create, :document => ''
      assert_response 400      
    end
  end
  
  def test_should_return_client_error_on_malformed_document
    assert_no_difference "Source.count" do
      post :create, :document => '<book'
      assert_response 400      
    end
  end
  
  protected
    def method_missing(method_name, *arguments)
      if /editions|facsimiles|manuscripts|works/.match method_name.id2name
        document("#{method_name}/#{arguments}")
      else
        raise NoMethodError
      end
    end
      
    def document(name)
      File.open(File.join(talia_core_fixtures, name + '.xml'))
    end
    
    def talia_core_fixtures
      @talia_core_fixtures ||= begin
        File.join(File.expand_path(RAILS_ROOT),
          'vendor', 'plugins', 'talia_core',
          'test', 'talia_util', 'import_samples')
      end
    end
    
    def documents_root
      @documents_root ||= File.join(File.expand_path(RAILS_ROOT),
        'test', 'fixtures', 'import')
    end
end
