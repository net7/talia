module TaliaCore
  
  # Refers to a paragraph in a work
  class Paragraph < ExpressionCard


    # adds the information about the chapter this annotation is in (if any)
    # It is asked to the page this paragraph is in.
    def calculate_chapter!
      qry = Query.new(TaliaCore::Source).select(:c).distinct.limit(1)
      qry.where(self, N::HYPER.note, :n)
      qry.where(:n, N::HYPER.page, :p)
      qry.where(:p, N::HYPER.chapter, :c)
      chapters = qry.execute
      self[N::HYPER.chapter] = chapters[0] unless chapters.empty?  
    end
  end
end
