class CreateSrecordDirtyRelations < ActiveRecord::Migration
  def self.up
    create_table "srecord_dirty_relations", :force => true do |t|
      t.column :source_record_id,   :integer, :null => false
      t.column :dirty_uri,          :string, :null => false
    end
  end

  def self.down
    drop_table "srecord_dirty_relations"
  end
end
