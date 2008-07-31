module TaliaCore
  
  # Refers to a chapter in a book or other work
  class Chapter < ExpressionCard
    
    # NOT cloned: first_page
    clone_properties N::DCNS.title,
      N::HYPER.position,
      N::HYPER.name
      
  end
end
