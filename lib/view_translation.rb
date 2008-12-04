# Globalize::ViewTranslation customizations, extracted from Globalize,
# in order to simplify plugin update process.

Globalize::ViewTranslation.class_eval do
  # Find and paginate translations for given locale.
  def self.find_by_locale(locale, page, per_page)
    locale = Locale.new(locale)
    self.paginate_by_language_id(locale.language.id, :page => page, :per_page => per_page)
  end
  
  def self.find_by_locale_and_tr_key(locale, tr_keys)
    locale = Locale.new(locale)
    result = self.find(:all, :select => "tr_key, text",
      :conditions => ['language_id = ? and tr_key IN(?)', locale.language.id, tr_keys])
    result.inject({}) do |memo, record|
      memo[record.tr_key] = record.text
      memo
    end
  end
  
  # Update the translations with given id, otherwise create a new translation.
  def self.create_or_update(translations, locale)
    transaction do
      self.create extract_translations_to_create(translations, locale)
      keys, values = extract_translations_to_update(translations)
      self.update keys, values
    end
  end
  
  # Extract and normalize translations to pass them to <tt>ActiveRecord#create</tt>.
  # It select translations without an id and inject the <tt>language_id</tt>
  # for the given <tt>Locale</tt>.
  def self.extract_translations_to_create(translations, locale)
    language_id = Locale.new(locale).language.id
    result = translations.inject([]) do |result, translation|
      if translation['id'].blank?
        translation['language_id'] = language_id
        translation['pluralization_index'] = 1
        result << translation
      end
      result
    end
  end
  
  # Extract and normalize translations to pass them to <tt>ActiveRecord#update</tt>.
  # It select translations with an id in order to extract and made it an hash key,
  # useful for <tt>ActiveRecord#update</tt>.
  #
  # <tt>ActiveRecord#update</tt> accepts two params, an Array of ids and another one,
  # composed by the values to be updated, formatted in an Hash.
  #
  # Example:
  #   [ { "id" => "1", "tr_key" => "hello", "text" => "Hello!" },
  #     { "id" => "2", "tr_key" => "rabbit", "text" => "Rabbit" } ]
  #
  #   # => [ [1,2], [ {"tr_key" => "hello", "text" => "Hello!" },
  #                  { "tr_key" => "rabbit", "text" => "Rabbit" } ] ]
  def self.extract_translations_to_update(translations)
    result = translations.inject({}) do |result, translation|
      unless translation['id'].blank?
        id = translation.delete('id')
        result[id] = translation
      end
      result
    end
    [ result.keys, result.values ]
  end
end
