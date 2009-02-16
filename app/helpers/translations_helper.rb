# This is a proxy for Rails 2.2.0 i18n foreword compatibility.
module TranslationsHelper
  def translate(symbol)
    return symbol.t unless(@globalize)
    result = content_tag(:span, '&nbsp;', :id => "#{symbol.to_s}_activator", :class => 'translate_element')
    result << content_tag(:span, symbol.t, :id => symbol.to_s)
    result << content_tag(:script, :type => 'text/javascript') do
      "new InPlaceTranslator('#{symbol}');"
    end
  end
  alias_method :t, :translate
  
  def localize(object, *arguments)
    object.localize(*arguments)
  end
  alias_method :l, :localize
end
