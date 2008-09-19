require File.dirname(__FILE__) + '/../test_helper'

class TranslationsTest < Test::Unit::TestCase
  include AuthenticatedTestHelper

  def setup
    @controller = ApplicationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  uses_mocha 'TranslationsTest' do
    def test_should_proxy_symbol_translation
      symbol = :'namespaced.translation.for.rails.220'
      string = "Namespaced translation for Rails 2.2.0"
      Symbol.any_instance.expects(:t).returns(string)

      login_as :admin
      get :index # forcing request and session creation
      assert_equal string, @response.template.t(symbol)
    end    
  end

  def test_should_proxy_integer_localization
    with_locale 'it-IT' do
      integer = 100_000

      login_as :admin
      get :index # forcing request and session creation
      assert_equal "100.000", @response.template.l(integer)
    end
  end

  def test_should_proxy_float_localization
    with_locale 'it-IT' do
      float = 23.06

      login_as :admin
      get :index # forcing request and session creation
      assert_equal "23,06", @response.template.l(float)
    end
  end
  
  def test_should_proxy_time_localization
    time = Time.utc(2000, 1, 1)
    
    login_as :admin
    get :index # forcing request and session creation
    assert_equal "01-01-2000", @response.template.l(time, "%d-%m-%Y")
  end
  
  private
    def with_locale(locale, &block)
      old_locale = Locale.active
      Locale.set(locale)
      yield
      Locale.set(old_locale)
    end
end
