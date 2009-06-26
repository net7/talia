# This is a proxy for Rails 2.2.0 i18n foreward compatibility.
module TranslationsHelper
  def translate(symbol, in_place_allowed = true)
    return symbol.t unless(@globalize && in_place_allowed)
    esc_symbol =ViewTranslation::s_encode(symbol.to_s.gsub(/_/, ' '))
    result = content_tag(:span, '&nbsp;', :id => "#{esc_symbol}_activator", :class => 'translate_element', :onclick => "translate_shadow('#{esc_symbol}'); return false;")
    result << content_tag(:span, symbol.t, :id => esc_symbol.to_s)
  end
  alias_method :t, :translate

  # Fetch the translation for the given key, it returns +nil+ in case of missing result.
  # This behavior breaks the default of Globalize, which returns the key itself, if the
  # translation is missing.
  #
  # This is the new default of the i18n gem.
  def translate_raw(symbol)
    ViewTranslation.find_by_locale_and_tr_key(Locale.active.code, symbol).text rescue nil
  end
  alias_method :t_raw, :translate_raw

  def translate_field(code, trans)
    translation = trans[:translation]
    text = (translation && translation.text) ? translation.text : ''
    if(text.size > 50)
      text_area_tag(code, text, :rows => 5, :cols => 45)
    else
      text_field_tag(code, text, :size => 50)
    end
  end
  
  def localize(object, *arguments)
    object.localize(*arguments)
  end
  alias_method :l, :localize
  
  # Helper to iterate over the @languages hash in an ordered fashion
  def each_language
    @translations.keys.sort.each do |lang|
      yield(lang, @translations[lang])
    end
  end
end
