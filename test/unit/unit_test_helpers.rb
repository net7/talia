require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

module TaliaCore
  
  module UnitTestHelpers
    
    # Creates dummy bookd with pages
    def create_dummy_book(name)
      book = Book.new(name)
      book.save!
      (1..4).each do |n| 
        page = Page.new("#{name}-page#{n}")
        page.hyper::is_part_of << book
        page.save!
        facsimile = Facsimile.new("#{name}-facsimile#{n}")
        page.add_manifestation(facsimile)
        facsimile.save!
      end
      book
    end
    
  end
  
end
