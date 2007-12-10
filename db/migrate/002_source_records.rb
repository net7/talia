class SourceRecords < ActiveRecord::Migration
  def self.up
    create_table :source_records, :options => "engine=InnoDB default charset=utf8" do |t|
      t.column :uri,            :string, :null => false
      t.column :name,           :string
      t.column :workflow_state, :integer
      t.column :primary_source, :boolean
    end
    add_index :source_records, :uri, :unique => true
  end

  def self.down
    drop_table :source_records
  end
end
