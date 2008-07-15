require File.join(File.dirname(__FILE__), "constraint_migration")

class CreateWorkflows < ConstraintMigration
  
  def self.up
    create_table "workflows", :force => true do |t|
      t.string :state, :null => false
      t.string :arguments, :null => false
      t.string :type
      t.references :source, :null => false
    end
    
    # Create the index 
    add_index :workflows, :source_id, :unique => true
    
    # Create the foreign key
    create_constraint("workflows", "active_sources", "source_id")
  end

  def self.down
    # drop the foreign key
    remove_constraint("workflows", "active_sources")

    # drop the table    
    drop_table "workflows"
  end
  
end
