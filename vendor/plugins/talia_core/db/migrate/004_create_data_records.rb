class CreateDataRecords < ActiveRecord::Migration
  def self.up
    create_table "data_records", :force => true do |t|
      t.column :source_record_id,   :integer, :null => false
      t.column :type,               :string,  :null => false
      t.column :location,           :string,  :null => false
    end
   
    add_index :data_records, :source_record_id, :unique => false
  end

  def self.down
    drop_table "data_records"
  end

end