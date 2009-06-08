require File.dirname(__FILE__) + '/../../test_helper'

class Globalize::ViewTranslationTest < Test::Unit::TestCase
  def test_extract_translations_to_create
    translations = [ { "id" => "1", "tr_key" => "hello", "text" => "Hello!" },
      { "id" => "", "tr_key" => "rabbit", "text" => "Rabbit" } ]
    expected = [ { "id" => "", "tr_key" => "rabbit", "text" => "Rabbit", "language_id" => 1, "pluralization_index" => 1, "built_in" => false } ]
    assert_equal expected, ViewTranslation.extract_translations_to_create(translations, locale)
  end
  
  def test_extract_translations_to_update
    translations = [ { "id" => "1", "tr_key" => "hello", "text" => "Hello!" },
      { "id" => "", "tr_key" => "rabbit", "text" => "Rabbit" } ]
    expected_keys = [ "1" ]
    expected_values = [ { "tr_key" => "hello", "text" => "Hello!" } ]
    keys, values = ViewTranslation.extract_translations_to_update(translations)
    assert_equal expected_keys, keys
    assert_equal expected_values, values
  end
  
  def test_should_not_update_or_create_translations_with_blank_values
    translations = [ { "id" => "", "tr_key" => "rabbit", "text" => "Rabbit" },
      { "id" => "", "tr_key" => "rabbit", "text" => "" } ]
    expected = [ { "id" => "", "tr_key" => "rabbit", "text" => "Rabbit", "language_id" => 1, "pluralization_index" => 1, "built_in" => false } ]
    assert_equal expected, ViewTranslation.extract_translations_to_create(translations, locale)
    
    translations = [ { "id" => "1", "tr_key" => "hello", "text" => "" } ]
    keys, values = ViewTranslation.extract_translations_to_update(translations)
    assert keys.empty?
    assert values.empty?
  end
  
  private
    def locale
      'en-US'
    end
end