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
    
    # Creates a dummy book with a number of pages
    def make_book(name, page_count = 0)
      book = Book.new("http://test_book/#{name}")
      book.save!
      page_count.times do |n|
        page = Page.new("http://test_book/#{name}-page#{n}")
        page.hyper::part_of << book
        page.save!
      end
      book
    end
    
  end
  
end
