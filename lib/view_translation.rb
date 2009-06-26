# Globalize::ViewTranslation customizations, extracted from Globalize,
# in order to simplify plugin update process.

Globalize::ViewTranslation.class_eval do
  # Find and paginate translations for given locale.
  # def self.find_by_locale(locale, page, per_page, options = {})
  #   locale = Locale.new(locale)
  #   self.paginate_by_language_id(locale.language.id, {:page => page, :per_page => per_page}.merge(options))
  # end

  # Find and paginate translations for given locale.
  def self.find_by_locale(locale, options = {})
    locale = Locale.new(locale)
    self.find_all_by_language_id(locale.language.id, options)
  end

  # Update the translations with given id, otherwise create a new translation.
  def self.create_or_update(translations, locale)
    transaction do
      self.create extract_translations_to_create(translations, locale)
      keys, values = extract_translations_to_update(translations)
      self.update keys, values
    end
  end

  # Find all translations for the given key. This will return a hash that contains all language codes
  # enabled in the system as keys, and the value will be a hash where :translation points to the
  # translation object and :lang_name to the language name
  def self.find_all_for(key)
    translations = self.find(:all, :conditions => ['language_id IN (?) AND tr_key = ?', language_ids, key])
    result = {}
    language_codes.each do |code, lang| 
      translation = translations.find { |tr| tr.language_id == lang[:id] }
      result[code] = { :translation => translation, :lang_name => lang[:name] } 
    end
    result
  end

  def self.find_by_locale_and_tr_key(locale, tr_key)
    locale = Locale.new(locale)
    self.find(:first, :select => "text",
      :conditions => ["language_id = ? and tr_key = ?", locale.language.id, tr_key.to_s])
  end

  def self.find_all_by_locale_and_tr_key(locale, tr_keys)
    locale = Locale.new(locale)
    result = self.find(:all, :select => "tr_key, text", :order => "tr_key ASC",
      :conditions => ['language_id = ? and tr_key IN(?)', locale.language.id, tr_keys])
    result.inject({}) do |memo, record|
      memo[record.tr_key] = record.text
      memo
    end
  end

  # Extract and normalize translations to pass them to <tt>ActiveRecord#create</tt>.
  # It select translations without an id and inject the <tt>language_id</tt>
  # for the given <tt>Locale</tt>.
  def self.extract_translations_to_create(translations, locale)
    language_id = Locale.new(locale).language.id
    result = translations.inject([]) do |result, translation|
      if translation['id'].blank? && !translation['text'].blank?
        translation['language_id'] = language_id
        translation['pluralization_index'] = 1
        translation['built_in'] = false
        result << translation
      end
      # clear the viewtranslations cache
      Locale.translator.cache_reset
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
      unless translation['id'].blank? || translation['text'].blank?
        id = translation.delete('id')
        result[id] = translation
      end
      result
    end
    [ result.keys, result.values ]
  end
  
  # Stupid encoding for quotes, in case someone does put them in translation keys, and
  # CGI::escape is mangled throuhgh internal Rails mechanis. 
  def self.s_encode(key)
    key.gsub(/'/, '__apos__').gsub(/"/, '__quote__')
  end
  
  # Unencode for the stupid encoding, see above
  def self.s_unencode(key)
    key.gsub(/__apos__/, "'").gsub(/__quote__/, '"')
  end  
  
  private
  
  # A list of all languages as ids
  def self.language_ids
    result = language_codes.collect { |code, lang| lang[:id].to_i }
  end
  
  # Language codes in the system, as a mapping hash. The language code is the key for each element, and
  # each element contains another hash, containing the :id and the :name of the language
  def self.language_codes
    @language_codes ||= begin
      codes = {}
      I18n.locales.values.each do |val| 
        locale = Locale.new(val)
        codes[val] = {:name => locale.language, :id => locale.language.id  }
      end
      codes
    end
  end
  
end
