class CreateSemanticRelations < ActiveRecord::Migration
  def self.up
    create_table :semantic_relations do |t|
      t.timestamps
      t.references :object, :polymorphic => true, :null => false
      t.references :subject, :class_name => 'ActiveSource', :null => false
      t.string :predicate_uri, :null => false
    end
    
    add_index :semantic_relations, :predicate_uri, :unique => false
    
  end

  def self.down
    drop_table :semantic_relations
  end
end
