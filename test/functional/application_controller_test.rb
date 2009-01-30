require 'yaml'
require File.dirname(__FILE__) + '/../test_helper'

class ApplicationControllerTest < Test::Unit::TestCase
  def setup
    @controller = ApplicationController.new
  end

  def test_languages
    expected = YAML.load_file(File.join(RAILS_ROOT, 'config', 'locales.yml')).to_hash
    assert_equal expected, @controller.class.languages
  end
end