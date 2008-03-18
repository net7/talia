class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  def self.find_all_names
    self.find(:all, :select => :name).map(&:name)
  end
end