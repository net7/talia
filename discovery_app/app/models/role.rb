class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
    
  def self.find_all_names
    self.find(:all, :select => :name).map(&:name)
  end
  
  def self.find_by_names(names)
    names = names.map(&:to_s)
    self.find(:all, :conditions => [ "name IN (?)", names])
  end
end