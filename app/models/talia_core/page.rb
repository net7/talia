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
      #TODO: as soon as ordered_source supports movements, use it
      #ordered_page.next
      TaliaCore::Page.find('N-IV-1,2')
    end
    
    def previous_page
      #TODO: as soon as ordered_source supports movements, use it
      #ordered_page.previous
      TaliaCore::Page.find('N-IV-1,2')
    end

    private
    def book_i_am_in
      qry = Query.new(TaliaCore::Book).select(:b).distinct
      qry.where(self, N::HYPER.part_of, :b)
      qry.execute[0]
    end

    def ordered_page
      book = book_i_am_in
      ordered_pages = OrderedSource.find(book.uri.to_s + '_ordered_pages')
      ordered_pages.find(self)
    end
  end
end