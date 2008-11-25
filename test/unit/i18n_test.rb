require 'test_helper'
require 'yaml'

class I18nTest < Test::Unit::TestCase
  def setup
    i18n_setup
  end
  
  def teardown
    i18n_teardown
  end
  
  def test_locales
    assert_equal({ :english => 'en-GB' }, I18n.locales)
  end
  
  def test_add_locale
    assert I18n.add_locale(:italian, 'it-IT')
    assert_equal({:english => 'en-GB', :italian => 'it-IT'}, I18n.locales)
  end
end