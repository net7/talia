module Admin::TranslationsHelper
  def add_translation
    link_to_function "Add a translation" do |page|
      page.insert_html :bottom, "translations", :partial => 'translation', :object => ViewTranslation.new
      page['translations'].select('.translation').last.focus
    end
  end
  
  def languages_picker
    content_tag(:div, :id => 'languages_picker') do
      returning result = "Pick a language: " do
        result << select_tag("languages", languages_options_tags, :onchange => change_language_function)
        result << " | #{add_translation}"
      end
    end
  end
  
  def languages_options_tags
    languages.map do |language, locale|
      language = language.to_s.titleize
      selected = locale == params[:id]
      value = edit_admin_translation_url(locale)
      content_tag(:option, language, :value => value, :selected => selected)
    end
  end
  
  def delete_admin_traslation_path(translation, params)
    admin_translation_path(translation) + "?locale=" + params[:id] + "&page=" + (params[:page] || "1")
  end
end
