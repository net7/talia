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
      # when paragraphs are cloned, the notes it is related to are not cloned too,
      # so we have that said notes are related to pages in the default catalog, even if the paragraph
      # itslef is not. 
      # We must separate, then, the two cases where the book (and so the paragraphs and
      # all the book's subparts) are in the default catalog or not.
      # In the latter case we have to refer to paragraphs and pages in the default catalog.
      qry = Query.new(TaliaCore::Paragraph).select(:p).distinct
      if self.catalog == TaliaCore::Catalog.default_catalog
        qry.where(:p, N::HYPER.note, :n)
        qry.where(:n, N::HYPER.page, self)
      else 
        qry.where(:para_concordance, N::HYPER.concordant_to, :def_para)
        qry.where(:para_concordance, N::HYPER.concordant_to, :p)
        qry.where(:def_para, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)        
        qry.where(:def_para, N::HYPER.note, :n)
        qry.where(:n, N::HYPER.page, :def_page)
        qry.where(:page_concordance, N::HYPER.concordant_to, :def_page)
        qry.where(:page_concordance, N::HYPER.concordant_to, self)
        # quite superflous as notes has relations (N::HYPER.page) only with pages in the default
        # catalog
        qry.where(:def_page, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
        qry.where(:p, N::HYPER.in_catalog, self.catalog)
      end
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
    
    def position_in_chapter
      unless chapter.nil?
        position = self.hyper.position[0].to_i - chapter.first_page.hyper.position[0].to_i  
        ("000000" + position)[-6..-1]
      end
    end
    
    # returns the Book this page is part of
    def book
      qry = Query.new(TaliaCore::Book).select(:b).distinct
      qry.where(self, N::HYPER.part_of, :b)
      qry.where(:b, N::RDF.type, N::HYPER.Book)
      qry.execute[0]
    end

    private
    # returns an OrderedSource object containig the pages in this book
    def ordered_pages
      book.ordered_pages
    end

  end
end