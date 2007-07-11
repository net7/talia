class CreateSrecordTypes < ActiveRecord::Migration
  def self.up
    create_table "srecord_types", :force => true do |t|
      t.column :source_record_id,   :integer, :null => false
      t.column :type_uri,           :string, :null => false
    end
  end

  def self.down
    drop_table "srecord_types"
  end
end
