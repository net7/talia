class CreateTypeRecords < ActiveRecord::Migration
  def self.up
    create_table "type_records", :force => true do |t|
      t.column :source_record_id,   :integer, :null => false
      t.column :uri,                :string, :null => false
    end
    
    # Create the foreign key
    execute "alter table type_records add constraint type_relations foreign key (source_record_id) references source_records(id)"
  end

  def self.down
     execute "alter table dirty_relation_records drop foreign key dirty_relations"
    drop_table "type_records"
  end
end
