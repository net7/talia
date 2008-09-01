module TaliaCore
  
  # Refers to a paragraph in a work
  class Paragraph < ExpressionCard


    # returns the chapter this paragraph is in (if any)
    def chapter
      candidate = nil
      qry = Query.new(TaliaCore::Source).select(:p).distinct.limit(1)
      qry.where(self, N::HYPER.part_of, :p)
      page = qry.execute[0]
      book.chapters.each do |chapter| 
        if   (chapter.first_page.hyper.position[0] <= page.hyper.position[0])
          candidate = chapter 
        end
      end 
      candidate
    end
    
    # returns the book this paragraph is in
    def book
      qry = Query.new(TaliaCore::Book).select(:b).distinct
      qry.where(self, N::HYPER.part_of, :p)
      qry.where(:p, N::HYPER.part_of, :b)
      qry.execute[0]
    end
 
    # returns the page(s) this paragraph is in
    def pages
      qry = Query.new(TaliaCore::Page).select(:p).distinct
      qry.where(self, N::HYPER.part_of, :p)
      qry.execute
    end
    
    def position_in_book
      
      qry = Query.new(TaliaCore::Page).select(:pos).distinct
      qry.where(self, N::HYPER.note, :n)
      qry.where(:n, N::HYPER.position, :pos)
      position = qry.execute
      # if this paragraph is in a MC, the notes are note cloned too, we must search with concordances
      unless !pages.empty?

        qry = Query.new(TaliaCore::Page).select(:pos).distinct
        qry.where(:concordance, N::HYPER.concordant_to, self)
        qry.where(:concordance, N::HYPER.concordant_to, :def_paragraph)
        qry.where(:def_paragraph, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
        qry.where(:def_paragraph, N::HYPER.note, :def_note)
        qry.where(:def_note, N::HYPER.position, :pos)
        pages = qry.execute
      end
      pages
      
      page_position = book.ordered_pages.find_position_by_object(pages[0])
            
      position = page_position + self.hyper.position
    end
  end
end
