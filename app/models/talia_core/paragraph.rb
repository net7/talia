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
    
  end
end
