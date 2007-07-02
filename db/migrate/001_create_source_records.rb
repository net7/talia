class CreateSourceRecords < ActiveRecord::Migration
  def self.up
    create_table "source_records", :force => true do |t|
      t.column :uri,                     :string
    end
  end

  def self.down
    drop_table "source_records"
  end
end
