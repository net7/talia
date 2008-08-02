module TaliaCore
  
  # A page in a book
  class Page < ExpressionCard
    
    # NOT cloned: part-of relationship
    clone_properties N::DCNS.title,
      N::HYPER.position,
      N::HYPER.position_name,
      N::HYPER.height, N::HYPER.width,
      N::HYPER.dimension_units,
      N::HYPER.siglum,
      N::RDF.type
    
  end
end