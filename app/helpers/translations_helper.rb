# This is a proxy for Rails 2.2.0 i18n foreward compatibility.
module TranslationsHelper
  def translate(symbol, in_place_allowed = true)
    return symbol.t unless(@globalize && in_place_allowed)
    esc_symbol =ViewTranslation::s_encode(symbol.to_s.gsub(/_/, ' '))
    result = content_tag(:span, '&nbsp;', :id => "#{esc_symbol}_activator", :class => 'translate_element', :onclick => "translate_shadow('#{esc_symbol}'); return false;")
    result << content_tag(:span, symbol.t, :id => esc_symbol.to_s)
  end
  alias_method :t, :translate
  
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
