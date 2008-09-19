# This is a proxy for Rails 2.2.0 i18n foreword compatibility.
module TranslationsHelper
  def translate(symbol)
    symbol.t
  end
  alias_method :t, :translate
  
  def localize(object, *arguments)
    object.localize(*arguments)
  end
  alias_method :l, :localize
end
