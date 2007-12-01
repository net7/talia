class CreateDataRecords < ActiveRecord::Migration
  def self.up
    create_table "data_records", :force => true do |t|
      t.column :source_record_id,   :integer, :null => false
      t.column :type,               :string,  :null => false
      t.column :location,           :string,  :null => false
    end
   
    # Create the index 
    add_index :data_records, :source_record_id, :unique => false
    
    # Create the foreign key
    execute "alter table data_records add constraint data_records_fkey foreign key (source_record_id) references source_records(id)"
  end

  def self.down
    # drop the foreign key
    execute "alter table data_records drop foreign key data_records_fkey"

    # drop the table    
    drop_table "data_records"
  end

end