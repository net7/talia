require File.dirname(__FILE__) + '/../../test_helper'

class Admin::LocalesControllerTest < ActionController::TestCase
  def setup
    i18n_setup
  end
  
  def teardown
    i18n_teardown
  end
  
  def test_create
    post :create, :name => "Italian", :code => 'it-IT'
    assert_equal({:english => 'en-GB', :italian => 'it-IT'}, I18n.locales)
    assert_redirected_to edit_admin_translation_path('it-IT')
  end
end
