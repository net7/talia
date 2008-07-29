require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

module TaliaCore
  
  module UnitTestHelpers
    
    # Creates a dummy expression card
    def make_card(name, save = true)
      c_name = self.class.to_s.gsub(/:+/, '_')
      card = ExpressionCard.new("http://#{c_name}/#{name}")
      card.save! if(save)
      card
    end
    
  end
  
end
