require File.dirname(__FILE__) + '/../test_helper'

class ApplicationControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper

  def setup
    @controller = ApplicationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_languages
    expected = { :english => 'en-US' }
    assert_equal expected, @controller.class.languages
  end
  
  def test_should_turn_on_translation_mode_for_translator
    login_as :translator
    get :index # forcing request and session creation
    assert @controller.globalize?
  end
  
  def test_should_turn_on_translation_mode_for_admin
    login_as :admin
    get :index # forcing request and session creation
    assert @controller.globalize?
  end
  
  def test_should_turn_off_translation_mode_for_not_allowed_user_roles
    login_as :quentin
    get :index # forcing request and session creation
    assert_false @controller.globalize?
  end
  
  uses_mocha 'ApplicationControllerTest' do
    def test_should_turn_off_translation_mode_for_not_allowed_controllers
      @controller.stubs(:controller_name).returns('widgeon')
      login_as :quentin
      get :index # forcing request and session creation
      assert_false @controller.globalize?
    end    
  end
end
