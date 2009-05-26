module TaliaCore
  
  # A page in a book. Note that cloning a page will not automatically clone 
  # paragraphs and notes belonging to this page.
  class Page < ExpressionCard
    DATA_PATH = File.join(TALIA_ROOT, "data")
    
    singular_property :position, N::HYPER.position
    singular_property :dimensions, N::DCT.extent
    singular_property :position_name, N::HYPER.position_name
    
    # NOT cloned: part-of relationship
    clone_properties N::DCT.extent
   
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
      qry.where(:note, N::RDF.type, N::HYPER.Note)
      qry.where(:note, N::HYPER.page, self)
      qry.execute     
    end

    # returns the chapter this page is in (if any)
    def chapter
      candidate = nil
      book.chapters.each do |chapter| 
        # We only know the first page of a chapter.
        # To know if this page belongs to a chapter, we need to go through all the chapters
        # of the book (which are ordered on their first_page position) and select the _last one_
        # whose first page has a position lesser than the position of this page.
        candidate = chapter if (chapter.first_page.hyper.position[0].to_i <= self.hyper.position[0].to_i)
      end 
      candidate
    end
    
    def position_in_chapter
      unless chapter.nil?
        position = self.hyper.position[0].to_i - chapter.first_page.hyper.position[0].to_i + 1
        "%0.6d" % position
      end
    end

    # return the position for search_key
    def position_for_search_key
      self.hyper.position.to_s + '000000'
    end
    
    # returns the Book this page is part of
    def book
      Book.find(:first, :find_through_inv => [N::DCT.isPartOf, self])
    end

    # Returns the facsimile for the page, if one exists. Nil otherwise. You have
    # name a type (e.g. 'Color', which correponds to hyper:Color) to select
    # the type of facsimile to return
    def facsimile(type)
      assit(type)
      facs_qry = Query.new(Source).select(:facsimile).distinct
      facs_qry.where(:facsimile, N::HYPER.manifestation_of, self)
      facs_qry.where(:facsimile, N::RDF.type, N::HYPER + 'Facsimile')
      facs_qry.where(:facsimile, N::RDF.type, N::HYPER + type)
      facs = facs_qry.execute
      assit(facs.size <= 1)
      (facs.size > 0) ? facs.first : nil
    end

    private
    
    # returns an OrderedSource object containig the pages in this book
    def ordered_pages
      book.ordered_pages
    end

  end
end