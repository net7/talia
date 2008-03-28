class CreateOpenId < ActiveRecord::Migration
  def self.up
        create_table :open_id_authentication_associations, :force => true do |t|
      t.integer :issued, :lifetime
      t.string :handle, :assoc_type
      t.binary :server_url, :secret
    end

    create_table :open_id_authentication_nonces, :force => true do |t|
      t.integer :timestamp, :null => false
      t.string :server_url, :null => true
      t.string :salt, :null => false
    end
    
    # add open_id column to users
    add_column :users, :open_id, :string, :default => nil    
  end

  def self.down
    # remove open_id column from users
    remove_column :users, :open_id
    
    drop_table :open_id_authentication_associations
    drop_table :open_id_authentication_nonces
  end
end
