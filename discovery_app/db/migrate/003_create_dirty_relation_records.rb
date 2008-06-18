require File.join(File.dirname(__FILE__), "constraint_migration")

class CreateDirtyRelationRecords < ConstraintMigration
  def self.up
    create_table "dirty_relation_records", :force => true do |t|
      t.column :source_record_id,   :integer, :null => false
      t.column :uri,                :string, :null => false
    end
    
    # Create the foreign key
    create_constraint("dirty_relation_records", "source_records")
  end

  def self.down
    remove_constraint("dirty_relation_records", "source_records")
    drop_table "dirty_relation_records"
  end
end
