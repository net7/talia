require File.join(File.dirname(__FILE__), "constraint_migration")

class CreateDataRecords < ConstraintMigration
  def self.up
    create_table "data_records", :force => true do |t|
      t.string :type
      t.string :location, :null => false
      t.string :mime
      t.references :source, :null => false
    end
   
    # Create the index 
    add_index :data_records, :source_id, :unique => false
    
    # Create the foreign key
    create_constraint("data_records", "active_sources", 'source_id')
  end

  def self.down
    # drop the foreign key
    remove_constraint("data_records", "active_sources")

    # drop the table    
    drop_table "data_records"
  end

end
