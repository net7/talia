require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

namespace :globalize do
  desc "Import translations from legacy tables."
  task :update do
    ActiveRecord::Schema.define do
      rename_table :globalize_translations, :globalize_legacy_translations

      create_table :globalize_translations, :force => true do |t|
        t.string :key, :null => false
        t.string :locale, :null => false
        t.string :pluralization_index, :null => false
        t.string :text
      end
    end

    class GlobalizeLanguage < ActiveRecord::Base
    end

    class GlobalizeLegacyTranslation < ActiveRecord::Base
      belongs_to :globalize_language, :foreign_key => :language_id
      set_inheritance_column nil
    end

    class GlobalizeTranslation < ActiveRecord::Base
    end

    # Load only user defined translations (table_name is nil)
    GlobalizeLegacyTranslation.find(:all, :conditions => {:table_name => nil}).each do |legacy_translation|
      GlobalizeTranslation.create :key => legacy_translation.tr_key,
        :locale => legacy_translation.globalize_language.iso_639_1,
        :pluralization_index => legacy_translation.pluralization_index,
        :text => legacy_translation.text
    end

    ActiveRecord::Schema.define do
      drop_table :globalize_countries
      drop_table :globalize_languages
      drop_table :globalize_legacy_translations
    end
  end
end