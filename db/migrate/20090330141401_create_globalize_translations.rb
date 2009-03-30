class CreateGlobalizeTranslations < ActiveRecord::Migration
  def self.up
    create_table :globalize_translations do |t|
      t.string :key, :null => false
      t.string :locale, :null => false
      t.string :pluralization_index, :null => false
      t.string :text
    end
  end

  def self.down
    drop_table :globalize_translations
  end
end
