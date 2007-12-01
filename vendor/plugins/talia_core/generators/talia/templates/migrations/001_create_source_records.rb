class CreateSourceRecords < ActiveRecord::Migration
  def self.up
    create_table "source_records", :force => true do |t|
      t.column :uri,            :string, :null => false
      t.column :name,           :string
      t.column :workflow_state, :integer, :null => false
      t.column :primary_source, :bool, :null => false
    end
    
    add_index :source_records, :uri, :unique => true
  end

  def self.down
    drop_table "source_records"
  end
end
