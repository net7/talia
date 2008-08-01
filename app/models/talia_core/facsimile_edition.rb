module TaliaCore 
  class FacsimileEdition < Catalog
    # returns an array containing a list of the book types available and connected to this facsimile edition
    # (e.g.: 'Works', 'Manuscripts', ...)
    def types
      @types ||= begin
        qry = Query.new(N::SourceClass).select(:t).distinct
        qry.where(:t, N::RDFS.subClassOf, N::HYPER.Material)
        qry.where(self, N::HYPER.usedType, :t)
        qry.execute
      end
    end
    
    # returns an array containing a list of available subtypes of the given type. Of course they must
    # be present in the facsimile edition we're in
    def subtypes(type)
      assit_quack(type, :uri)
      @subtypes ||= {}
      @subtypes[type.to_s] ||= begin
        qry = Query.new(N::SourceClass).select(:t).distinct
        qry.where(:t, N::RDFS.subClassOf, type)
        qry.where(self, N::HYPER.usedType, :t)
        qry.execute
      end
    end
    
    # Returns an array containing a list of all the elements of the given type 
    # (manuscripts, works, etc.). Types can also contain subtypes (notebook, draft, etc.) 
    # 
    # The types should be a list of N::URI elements indicating the RDF classes.
    def elements(*types)
      qry = Query.new(TaliaCore::Source).select(:element).distinct
      types.each do |type|
        assit_quack(type, :uri)
        qry.where(:element, N::RDF.type, type)
      end
      qry.where(:element, N::HYPER.in_catalog, self)
      qry.execute
    end
    
    # Returns all the books in the catalog. See elements
    def books(*types)
      types << N::TALIA.Book
      elements(*types)
    end
    
    # Search for the given book and page (only the book if no page is given).
    # If the page is not given, this will return all pages of the book.
    def search(requested_book, requested_page = nil)
      return [] unless requested_book
      qry = Query.new(TaliaCore::Source).select(:p).distinct.limit(1)
      qry.where(:b, N::HYPER.siglum, requested_book)
      qry.where(:p, N::HYPER.part_of, :b)
      qry.where(:p, N::HYPER.position_name, requested_page) if(requested_page)
      qry.sort(:p, N::HYPER.position, :pos)
      qry.execute 
    end
  
    # returns the left or right "neighbour" source of the given source.
    # movement is expected in the form of "next" or "previous"
    # used, for instance, for browsing pages
    def neighbour_page(page, movement)
      "N-IV-1,3"
    end
    
  end
end