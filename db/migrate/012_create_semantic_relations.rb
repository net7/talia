class CreateSemanticRelations < ActiveRecord::Migration
  def self.up
    create_table :semantic_relations do |t|
      t.timestamps
      t.references :object, :polymorphic => true, :null => false
      t.references :subject, :class_name => 'ActiveSource', :null => false
      t.string :predicate_uri, :null => false
    end
    
  end

  def self.down
    drop_table :semantic_relations
  end
end
