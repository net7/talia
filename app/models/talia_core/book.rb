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
    
    # The chapters of this book
    def chapters
      qry = Query.new(TaliaCore::Chapter).select(:c).distinct
      qry.where(:c, N::HYPER.book, self)
      qry.where(:c, N::HYPER.first_page, :p)
      qry.where(:p, N::HYPER.position, :pos)
      qry.sort(:pos)
      qry.execute  
    end
    
    # Creates an OrderedSource object for this` book containing all its pages, 
    # ordered by their position
    def order_pages!
      ordered = ordered_pages
      qry = Query.new(TaliaCore::Page).select(:p).distinct
      qry.where(:p, N::HYPER.part_of, self)
      qry.where(:p, N::HYPER.position, :pos)
      qry.sort(:pos)
      pages = qry.execute
      pages.each do |page| 
        ordered.add(page)
        ordered.save!
      end

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
    
    def ordered_pages_elements
      ordered_pages.elements      
    end

    # returns the RDF.type of this book (e.g. Manuscript, Work, etc.)
    def type 
      qry = Query.new(TaliaCore::Source).select(:type).distinct
      qry.where(:self, N::RDF.type, :subtype)
      qry.where(:subtype, N::RDFS.subClassOf, :type)
      qry.where(:type, N::RDFS.subClassOf, N::HYPER.Material)
      qry.execute[0]
    end
  
    # returns the subClass of the RDF.type of this book (e.g. Copybook, Notebook, etc.) 
    def subtype 
      qry = Query.new(TaliaCore::Source).select(:subtype).distinct
      qry.where(:self, N::RDF.type, :subtype)
      qry.where(:subtype, N::RDFS.subClassOf, :type)
      qry.where(:type, N::RDFS.subClassOf, N::HYPER.Material)
      qry.execute[0]
    end
    
    # Returns the PDF representation of this book
    def pdf
      # TODO: Implementation
    end
   
  end
end
