require File.dirname(__FILE__) + '/../../test_helper'

class Admin::LocalesControllerTest < ActionController::TestCase
  def setup
    i18n_setup
  end
  
  def teardown
    i18n_teardown
  end
  
  def test_should_get_new
    get :new
    assert_select "form" do
      assert_select "[action=?]", "/admin/locales"
      assert_select "input[type=text][name=name]", :count => 1
      assert_select "input[type=text][name=code]", :count => 1
      assert_select "input[type=submit][value=?]", "Create"
      assert_select "a[href=?]", "/admin/translations", :value => "back to the translations"
    end
  end
  
  def test_create
    post :create, :name => "Italian", :code => 'it-IT'
    assert_equal({:english => 'en-GB', :italian => 'it-IT'}, I18n.locales)
    assert_redirected_to edit_admin_translation_path('it-IT')
  end
  
  def test_should_report_error_on_invalid_locale_creation
    post :create, :name => "Italian", :code => 'it-PO'
    assert_equal({:english => 'en-GB'}, I18n.locales)
    assert_template 'new'
    assert_flash_error "Invalid locale, please check the format and make sure the language is available."
  end
end