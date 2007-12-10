class SourceTypeRecords < ActiveRecord::Migration
  def self.up
    create_table :source_type_records, :options => "engine=InnoDB default charset=utf8" do |t|
      t.column :source_record_id, :integer, :null => false
      t.column :uri,              :string,  :null => false
    end
  end

  def self.down
    drop_table :source_type_records
  end
end
