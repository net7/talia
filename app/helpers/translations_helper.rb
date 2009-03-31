module TranslationsHelper
  # def translate_with_in_place_translator(symbol, options = {}, in_place_allowed = true)
  #   return translate_without_in_place_translator(symbol, options) unless @globalize && in_place_allowed
  #   result = content_tag(:span, '&nbsp;', :id => "#{symbol.to_s}_activator", :class => 'translate_element')
  #   result << content_tag(:span, symbol.t, :id => symbol.to_s)
  #   result << content_tag(:script, :type => 'text/javascript') do
  #     "new InPlaceTranslator('#{symbol}');"
  #   end
  # end
  # alias_method_chain :translate, :in_place_translator
end
