require File.join(File.dirname(__FILE__), "constraint_migration")

class CreateDataRecords < ConstraintMigration
  def self.up
    create_table "data_records", :force => true do |t|
      t.column :source_record_id,   :integer, :null => false
      t.column :type,               :string,  :null => false
      t.column :location,           :string,  :null => false
    end
   
    # Create the index 
    add_index :data_records, :source_record_id, :unique => false
    
    # Create the foreign key
    create_constraint("data_records", "source_records")
  end

  def self.down
    # drop the foreign key
    remove_constraint("data_records", "source_records")

    # drop the table    
    drop_table "data_records"
  end

end
