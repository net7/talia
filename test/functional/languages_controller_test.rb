require File.dirname(__FILE__) + '/../test_helper'

class LanguagesControllerTest < ActionController::TestCase  
  def test_should_change_language
    prepare_test
    get :change, :id => 'it-IT'
    assert_redirected_to @referer
    assert_equal 'it-IT', Locale.active.code
  end
  
  def test_should_not_change_language_on_missing_code
    prepare_test
    get :change
    assert_redirected_to @referer
    assert_equal 'en-US', Locale.active.code
  end
  
  private
    def prepare_test
      # For some strange reason #setup isn't called.
      Locale.set('en-US')
      @referer = 'http://localhost:3000'
      @request.env["HTTP_REFERER"] = @referer
    end
end
