module TaliaCore
  
  # A page in a book
  class Page < ExpressionCard
    
    # NOT cloned: part-of relationship
    clone_properties N::DCNS.title,
      N::HYPER.position,
      N::HYPER.position_name,
      N::HYPER.height, N::HYPER.width,
      N::HYPER.dimension_units

    def next_page
      #      book = TaliaCore::Book.find(:find_through => [self, N::HYPER.part_of])
      book = book_i_am_in
    end
    def previous_page
      book = book_i_am_in
    end

    private
    def book_i_am_in
      TaliaCore::Book.find(:all, :find_through => [self, N::HYPER.part_of])
    end
  
  end
end