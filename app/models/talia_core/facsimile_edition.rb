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
    
    # returns an array containing a list of all the books of the given type 
    # (manuscripts, works, etc.) or subtype (notebook, draft, etc.) belonging 
    # to this Facsimile Edition. Books of a subtype also belong to the type
    # of which it is a subtype.
    def books(type = nil)
      assit_quack(type, :uri) if(type)
      qry = Query.new(TaliaCore::Source).select(:b).distinct
      qry.where(:b, N::RDF.type, type) if(type)
      qry.where(:b, N::HYPER.in_catalog, self)
      qry.execute
    end
    
    # Search for the given book and page (only the book if no page is given).
    # If the page is not given, this will return all pages of the book.
    # (FIXME: That behaviour ok?)
    def search(requested_book, requested_page = nil)
      qry = Query.new(Source).select(:p).distinct
      qry.where(:b, N::HYPER.siglum, requested_book)
      qry.where(:p, N::HYPER.is_part_of, :b)
      qry.where(:p, N::HYPER.siglum, requested_page) if(requested_page)
      qry.execute
    end
  
    # returns the left or right "neighbour" source of the given source.
    # movement is expected in the form of "next" or "previous"
    # used, for instance, for browsing pages
    def neighbour_source(source, movement)
      #TODO: Move to "Page"
      result = 'N-IV-2,3'
    end
    
  end
end