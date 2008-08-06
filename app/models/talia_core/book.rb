module TaliaCore
  
  
  # This refers to a book in a collection. Note that each book is 
  # exactly in one Catalog/Macrocontribution (see AbstractWorkCard).
  class Book < ExpressionCard
    
    # NOT cloned: in_archive
    clone_properties N::DCNS.title,
      N::HYPER.position,
      N::DCNS.description,
      N::DCNS.date,
      N::DCNS.publisher,
      N::HYPER.publication_place,
      N::HYPER.copyright_note
    # The pages of this book
    def pages
      Page.find(:all, :find_through => [N::HYPER.part_of, self])
    end
    
    # Creates an OrderedSource object for this book containing all its pages, 
    # ordered by their position
    def order_pages!
      ordered_pages = OrderedSource.new(self.uri.to_s + '_ordered_pages')
      qry = Query.new(TaliaCore::Page).select(:p).distinct
      qry.where(:p, N::HYPER.part_of, self)
      qry.where(:p, N::HYPER.position, :pos)
      qry.sort(:pos)
      pages = qry.execute
      pages.each do |page| 
        ordered_pages.add(page)
        ordered_pages.save!
      end

    end
    
    # Returns an array containing all the pages in this book, ordered
    def ordered_pages
      OrderedSource.find(self.uri.to_s + '_ordered_pages').elements
    end

    # A descriptive text about this book
    def material_description
      description = inverse[N::HYPER.description_of]
      assit(description.size <= 1, "There shouldn't be multiple descriptions")
      (description.size > 0) ? description[0] : ''
    end
    
    # Returns the PDF representation of this book
    def pdf
      # TODO: Implementation
    end
   
  end
end
