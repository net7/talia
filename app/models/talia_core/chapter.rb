module TaliaCore
  
  # Refers to a chapter in a book or other work
  class Chapter < ExpressionCard
    
    singular_property :first_page, N::HYPER.first_page
    singular_property :book, N::HYPER.book
        
    def ordered_pages_elements
      ordered_pages.elements      
    end
    
    # creates an ordered_source object containing all the pages belonging to this
    # chapter
    def order_pages!
      # since we only know the first page of a chapter, constructing the ordered_pages
      # object is a bit tricky
      ordered = ordered_pages
      ordered.delete_all unless ordered.first.nil?
      
      book_chapters = book.chapters
      book_order = book.ordered_pages
      chapter_index = book_chapters.index(self) 
      next_chapter = book_chapters[chapter_index + 1]

      first_position = book_order.find_position_by_object(self.first_page)
      last_position = if(next_chapter)
        book_order.find_position_by_object(next_chapter.first_page) - 1
      else
        book_order.ordered_objects.size - 1
      end

      # Go through the pages
      (first_position..last_position).each do |index|
        ordered.add(book_order.ordered_objects[index])
      end
      
      ordered.save!
    end
    
    # Returns an array containing all the pages in this chapter, ordered
    def ordered_pages
      uri = self.uri.to_s + '_ordered_pages'
      if OrderedSource.exists?(uri)
        OrderedSource.find(uri)
      else
        OrderedSource.new(uri)
      end
    end

    
    # overrides the expression_card method 
    def subparts_with_manifestations(manifestation_type, subpart_type = nil)
      # if there are manifestations of both pages and annotations it'll return
      # all the pages first, and then all the annotations (ordering annotations
      # between pages may result in unproper orders)
      pages = []
      paragraphs = []
      ordered_pages.elements.each do |page|
        if (subpart_type == nil || subpart_type == N::HYPER.Page) 
          qry_page = Query.new(TaliaCore::Page).select(:m).distinct
          qry_page.where(:m, N::HYPER.manifestation_of, page)
          qry_page.where(:m, N::RDF.type, manifestation_type)
          pages << page unless qry_page.execute.empty?
        end 

        if (subpart_type == nil || subpart_type == N::HYPER.Paragraph)
          qry_para = Query.new(TaliaCore::Paragraph).select(:p).distinct
          qry_para.where(:note, N::HYPER.page, page)
          qry_para.where(:note, N::RDF.type, N::HYPER.Note)
          qry_para.where(:p, N::HYPER.note, :note)
          qry_para.where(:m, N::HYPER.manifestation_of, :p)
          qry_para.where(:m, N::RDF.type, manifestation_type)
          qry_para.where(page, N::HYPER.position, :page_pos)
          qry_para.where(:note, N::HYPER.position, :note_pos)
          qry_para.sort(:page_pos)
          qry_para.sort(:note_pos)
          qry_para.execute.each do |par|
            paragraphs << par
          end
        end
      end
      (pages + paragraphs)
    end    
    
  end
end
