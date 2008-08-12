module TaliaCore
  
  # A page in a book
  class Page < ExpressionCard
    
    # NOT cloned: part-of relationship
    clone_properties N::DCNS.title,
      N::HYPER.position,
      N::HYPER.position_name,
      N::HYPER.height, N::HYPER.width,
      N::HYPER.dimension_units

    # returns the following page
    def next_page
      ordered_pages.next_element(self)      
    end

    # returns the previous page
    def previous_page
      ordered_pages.previous_element(self)      
    end
    
    private
    # returns the Book this page is part of
    def book_i_am_in
      qry = Query.new(TaliaCore::Book).select(:b).distinct
      qry.where(self, N::HYPER.part_of, :b)
      qry.execute[0]
    end

    # returns an OrderedSource object containig the pages in this book
    def ordered_pages
      book_i_am_in.ordered_pages
    end

  end
end