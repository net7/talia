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
      ordered_pages.next(self)      
    end

    # returns the previous page
    def previous_page
      ordered_pages.previous(self)      
    end
    
    # returns all the paragraphs belonging to this page
    def paragraphs
      qry = Query.new(TaliaCore::Paragraph).select(:a).distinct
      qry.where(:a, N::HYPER.note, :n)
      qry.where(:n, N::HYPER.page, self)
      qry.execute     
    end

    # returns the chapter this page is in (if any)
    def chapter
      candidate = nil
      book.chapters.each do |chapter| 
        if   (chapter.first_page.hyper.position[0] <= self.hyper.position[0])
          candidate = chapter 
        end
      end 
      candidate
    end
    
    # returns the Book this page is part of
    def book
      qry = Query.new(TaliaCore::Book).select(:b).distinct
      qry.where(self, N::HYPER.part_of, :b)
      qry.execute[0]
    end

    private
    # returns an OrderedSource object containig the pages in this book
    def ordered_pages
      book.ordered_pages
    end

  end
end