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
      qry = Query.new(TaliaCore::Page).select(:page).distinct
      qry.where(self, N::HYPER.note, :note)
      qry.where(:note, N::RDF.type, N::HYPER.Note)
      qry.where(:note, N::HYPER.page, :page)
      qry.execute
    end
    
    def notes
      qry = Query.new(TaliaCore::Note).select(:note).distinct
      qry.where(self, N::HYPER.note, :note)
      qry.execute
    end
    
    def position_in_book
      page_position = pages[0].hyper.position[0]
      note_position = notes[0].hyper.position[0]
      position = page_position + note_position
    end
  end
end
