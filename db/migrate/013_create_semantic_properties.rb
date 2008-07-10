class CreateSemanticProperties < ActiveRecord::Migration
  def self.up
    create_table :semantic_properties do |t|
      t.timestamps
      t.string :value
    end
  end

  def self.down
    drop_table :semantic_properties
  end
end
