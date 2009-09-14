class CreateCustomTemplates < ActiveRecord::Migration
  def self.up
    create_table :custom_templates do |t|

      t.timestamps
      t.string :name, :null => false
      t.string :template_type, :null => false
      t.text :content, :null => false
    end

    add_index :custom_templates, :name, :unique => true
  end

  def self.down
    drop_table :custom_templates
  end
end
