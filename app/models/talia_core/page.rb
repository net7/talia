module TaliaCore
  
  # A page in a book. Note that cloning a page will not automatically clone 
  # paragraphs and notes belonging to this page.
  class Page < ExpressionCard
    
    singular_property :position, N::HYPER.position
    singular_property :height, N::HYPER.height
    singular_property :width, N::HYPER.width
    singular_property :position_name, N::HYPER.position_name
    
    # NOT cloned: part-of relationship
    clone_properties N::HYPER.height, N::HYPER.width,
      N::HYPER.dimension_units
   
    # returns the following page
    def next_page
      ordered_pages.next(self)      
    end

    # returns the previous page
    def previous_page
      ordered_pages.previous(self)      
    end
    
    # The notes belonging to this page
    def notes
      TaliaCore::Note.find(:all, :find_through => [N::HYPER.page, self])
    end
    
    # All paragraphs that are on this page (meaning that notes from those
    # paragraphs appear on the page.
    def paragraphs
      qry = Query.new(TaliaCore::Paragraph).select(:paragraph).distinct
      qry.where(:paragraph, N::HYPER.note, :note)
      qry.where(:note, N::HYPER.page, self)
      qry.execute     
    end

    # returns the chapter this page is in (if any)
    def chapter
      book.chapters.each do |chapter| 
        return chapter if (chapter.first_page.hyper.position[0] <= self.hyper.position[0])
      end 
      nil
    end
    
    def position_in_chapter
      unless chapter.nil?
        position = self.hyper.position[0].to_i - chapter.first_page.hyper.position[0].to_i  
        ("000000" + position)[-6..-1]
      end
    end
    
    # returns the Book this page is part of
    def book
      Book.find(:first, :find_through_inv => [N::HYPER.part_of, self])
    end

    private
    
    # returns an OrderedSource object containig the pages in this book
    def ordered_pages
      book.ordered_pages
    end

  end
end