require File.join(File.dirname(__FILE__), "constraint_migration")

class CreateWorkflowRecords < ConstraintMigration
  
  def self.up
    create_table "workflow_records", :force => true do |t|
      t.column :source_record_id,     :integer,     :null => false
      t.column :state,                :string,      :null => false
    end
    
    # Create the index 
    add_index :workflow_records, :source_record_id, :unique => true
    
    # Create the foreign key
    create_constraint("workflow_records", "source_records")
  end

  def self.down
    # drop the foreign key
    remove_constraint("workflow_records", "source_records")

    # drop the table    
    drop_table "workflow_records"
  end
  
end
