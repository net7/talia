module Admin::TranslationsHelper
  # Always pick fresh locales, instead of rely on application.rb
  # This because application.rb is evaluated once in production mode.
  # TODO: Rely on globalize2 when migrate to Rails 2.2.2
  delegate :locales, :to => I18n
  
  def add_translation
    link_to_function "Add a translation" do |page|
      page.insert_html :bottom, "translations", :partial => 'translation', :object => ViewTranslation.new
      page['translations'].select('.translation').last.focus
    end
  end

  def add_locale
    link_to "Add locale", :controller => 'admin/locales', :action => 'new'
  end
  
  def languages_picker
    content_tag(:div, :id => 'languages_picker') do
      returning result = "Pick a language: " do
        result << select_tag("languages", languages_options_tags, :onchange => change_language_function)
        result << " | #{reference_translations_picker} | #{add_locale} | #{add_translation}"
      end
    end
  end

  def reference_translations_picker
    returning result = "Load translations: " do
      result << select_tag("reference_languages", languages_options_tags(false))
    end
  end
  
  def languages_options_tags(include_url = true)
    locales.map do |language, locale|
      language = language.to_s.titleize
      selected = locale == params[:id]
      value = include_url ? edit_admin_translation_url(locale) : locale
      content_tag(:option, language, :value => value, :selected => selected)
    end
  end

  def delete_admin_traslation_path(translation, params)
    admin_translation_path(translation) + "?locale=" + params[:id] + "&page=" + (params[:page] || "1")
  end
end
