module TaliaCore
  
  # Refers to a chapter in a book or other work
  class Chapter < ExpressionCard
    
    # NOT cloned: first_page
    clone_properties N::DCNS.title,
      N::HYPER.position,
      N::HYPER.name,
      N::HYPER.first_page,
      N::HYPER.book
    def first_page
      Page.find(self.hyper.first_page).uniq[0]
    end
       
    def book
      Book.find(self.hyper.book).uniq[0]
    end  
        
    def ordered_pages_elements
      ordered_pages.elements      
    end
    
    # creates an ordered_source object containing all the pages belonging to this
    # chapter
    def order_pages!
      # since we only know the first page of a chapter, constructing the ordered_pages
      # object is a bit tricky
      ordered = ordered_pages
      book_chapters = book.chapters
      chapter_index = book_chapters.index(self)
      next_chapter = book_chapters[chapter_index + 1]
      starting_page = self.hyper.first_page[0]
      ending_page = next_chapter.hyper.first_page[0] unless next_chapter.nil?  
      starting_page_position = book.ordered_pages.find_position_by_object(starting_page)        
      if ending_page.nil? 
        ending_page_position = book.ordered_pages.size 
      else 
        ending_page_position = book.ordered_pages.find_position_by_object(ending_page) - 1
      end
      ordered.add temp_page = book.ordered_pages.at(starting_page_position)
      while self.book.ordered_pages.find_position_by_object(temp_page) < ending_page_position
        ordered.add temp_page = book.ordered_pages.next(temp_page)   
      end    
      ordered.save!
    end
    
    # Returns an array containing all the pages in this book, ordered
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
      annotations = []
      ordered_pages_elements.each do |page|
        qry_page = Query.new(TaliaCore::Source).select(:m).distinct
        qry_page.where(:m, N::HYPER.manifestation_of, page.object)
        qry_page.where(:m, N::RDF.type, manifestation_type)
        pages << page.object unless qry_page.execute.empty?
        
        qry_para = Query.new(TaliaCore::Paragraph).select(:p).distinct
        if (self.catalog != TaliaCore::Catalog.default_catalog)
  
          qry_para.where(:note, N::HYPER.page, :def_page)
          qry_para.where(:def_page, N::HYPER.in_catalog, TaliaCore::Catalog.default_catalog)
          qry_para.where(:page_concordance, N::HYPER.concordant_to, :def_page)
          qry_para.where(:page_concordance, N::HYPER.concordant_to, page.object)
          qry_para.where(:def_para, N::HYPER.note, :note)
          qry_para.where(:para_concordance, N::HYPER.concordant_to, :def_para)
          qry_para.where(:para_concordance, N::HYPER.concordant_to, :p)
          qry_para.where(:p, N::HYPER.in_catalog, self.catalog)
          qry_para.where(:p, N::RDF.type, subpart_type) unless subpart_type.nil?
          qry_para.where(:m, N::HYPER.manifestation_of, :p)
          qry_para.where(:m, N::RDF.type, manifestation_type)
          qry_para.where(:def_page, N::HYPER.position, :page_pos)
          qry_para.where(:note, N::HYPER.position, :note_pos)
          qry_para.sort(:page_pos)
          qry_para.sort(:note_pos)
        else
          qry_para.where(:note, N::HYPER.page, page.object)
          qry_para.where(:p, N::HYPER.note, :note)
          qry_para.where(:p, N::RDF.type, subpart_type) unless subpart_type.nil?
          qry_para.where(:m, N::HYPER.manifestation_of, :p)
          qry_para.where(:m, N::RDF.type, manifestation_type)
          qry_para.where(page.object, N::HYPER.position, :page_pos)
          qry_para.where(:note, N::HYPER.position, :note_pos)
          qry_para.sort(:page_pos)
          qry_para.sort(:note_pos)
          
        end
        qry_para.execute.each do |a|
          annotations << a
        end
      end
      subparts = pages + annotations
    end    
    
  end
end
