module Admin::TranslationsHelper
  def add_translation
    link_to_function "Add a translation" do |page|
      page.insert_html :bottom, "translations", :partial => 'translation', :object => ViewTranslation.new
      page['translations'].select('.translation').last.focus
    end
  end
  
  def languages_menu
    content_tag(:div, :id => 'languages_menu') do
      returning result = "Pick a language: " do
        result << select_tag("languages", languages_options_tags, :onchange => goto_language_page_function)
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
  
  def goto_language_page_function
    "javascript:window.location.href = this.options[this.selectedIndex].value;"
  end
end
