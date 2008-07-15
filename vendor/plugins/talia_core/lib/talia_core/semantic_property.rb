module TaliaCore
  
  class SemanticProperty < ActiveRecord::Base
    validates_presence_of :value
  end
  
end
