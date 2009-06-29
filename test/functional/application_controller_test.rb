require 'yaml'
require File.dirname(__FILE__) + '/../test_helper'

class ApplicationControllerTest < Test::Unit::TestCase
  def setup
    @controller = ApplicationController.new
  end

  def test_i18n_languages
    expected = YAML.load_file(File.join(RAILS_ROOT, 'config', 'locales.yml')).to_hash.symbolize_keys!
    assert_equal expected, I18n.locales
  end
end