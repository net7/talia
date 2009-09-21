class CreateWords < ActiveRecord::Migration
  def self.up

    create_table :words do |t|
      t.string :word, :null => false
      t.float :counter,:null => false, :default => 1
      t.timestamps
    end

    # Create the index
    add_index :words, :word, :unique => true

  end

  def self.down
    drop_table :words
  end
end
