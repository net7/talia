module TaliaCore
  
  # Refers to a chapter in a book or other work
  class Chapter < ExpressionCard
    
    # NOT cloned: first_page
    clone_properties N::DCNS.title,
      N::HYPER.position,
      N::HYPER.name,
      # please note that first_page contains a relation to the original page, not the 
      # one we're creating as a clone. This is actually good, as we expect the original
      # page to exist always, while we may not clone it too in our new catalog.
      N::HYPER.first_page 
    def first_page
      Page.find(self.hyper.first_page).uniq[0]
    end
       
    def book
      Book.find(self.hyper.book)
    end  
  end
end
