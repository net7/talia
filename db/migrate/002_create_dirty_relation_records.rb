class CreateDirtyRelationRecords < ActiveRecord::Migration
  def self.up
    create_table "dirty_relation_records", :force => true do |t|
      t.column :source_record_id,   :integer, :null => false
      t.column :uri,                :string, :null => false
    end
  end

  def self.down
    drop_table "dirty_relation_records"
  end
end
