require File.join(File.dirname(__FILE__), "constraint_migration")

class CreateTypeRecords < ConstraintMigration
  def self.up
    
    create_table "type_records", :force => true do |t|
      t.column :source_record_id,   :integer, :null => false
      t.column :uri,                :string, :null => false
      puts "#{t.class}"
    end
    
    # Create the foreign key
    create_constraint("type_records", "source_records")
  end

  def self.down
    remove_constraint("type_records", "source_records")
    drop_table "type_records"
  end
end
