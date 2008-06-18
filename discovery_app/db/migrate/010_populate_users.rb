class PopulateUsers < ActiveRecord::Migration
  def self.up
    admins = Role.create :name => 'admin'
    Role.create :name => 'user'
    admin = User.create :login => 'admin', :email => 'admin@admins.foob',  :password => 'admin', :password_confirmation => 'admin'
    admin.roles << admins
  end

  def self.down
  end
end
