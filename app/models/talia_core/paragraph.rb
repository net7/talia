module TaliaCore
  
  # Refers to a paragraph in a work
  class Paragraph < ExpressionCard


    # returns the chapter this paragraph is in (if any)
    def chapter
      candidate = nil
      page = pages[0]
      book.chapters.each do |chapter| 
        if   (chapter.first_page.hyper.position[0] <= page.hyper.position[0])
          candidate = chapter 
        end
      end 
      candidate
    end
    
    # returns the book this paragraph is in
    def book
      pages[0].book
    end
 
    # returns the page(s) this paragraph is in
    def pages
      qry = Query.new(TaliaCore::Source).select(:page).distinct
      if self.catalog == TaliaCore::Catalog.default_catalog
        qry.where(self, N::HYPER.note, :note)
        qry.where(:note, N::HYPER.page, :page)
      else
        qry.where(:para_concordance, N::HYPER.concordant_to, :def_para)
        qry.where(:para_concordance, N::HYPER.concordant_to, self)
        qry.where(:def_para, N::HYPER.note, :note)
        qry.where(:note, N::HYPER.page, :def_page)
        qry.where(:page_concordance, N::HYPER.concordant_to, :def_page)
        qry.where(:page_concordance, N::HYPER.concordant_to, :page)
        qry.where(:page, N::HYPER.in_catalog, self.catalog)         
      end
      qry.execute
    end
    
    def notes
      qry = Query.new(TaliaCore::Source).select(:note).distinct
      if self.catalog == TaliaCore::Catalog.default_catalog
        qry.where(self, N::HYPER.note, :note)
      else
        qry.where(:para_concordance, N::HYPER.concordant_to, :def_para)
        qry.where(:para_concordance, N::HYPER.concordant_to, self)
        qry.where(:def_para, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
        qry.where(:def_para, N::HYPER.note, :note)
      end 
      qry.execute
    end
    
    def position_in_book
      page_position = pages[0].hyper.position[0]
      note_position = notes[0].hyper.position[0]
      position = page_position + note_position
    end
  end
end
