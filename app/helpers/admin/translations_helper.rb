module Admin::TranslationsHelper
  def add_translation
    link_to_function "Add" do |page|
      page.insert_html :bottom, "translations", :partial => 'translation', :object => ViewTranslation.new
    end
  end
end
