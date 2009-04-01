module TaliaCore 
  class FacsimileEdition < Catalog

    # URI prefix for editions
    EDITION_PREFIX = 'facsimiles'

    # returns an array containing a list of the book types available and connected to this facsimile edition
    # (e.g.: 'Works', 'Manuscripts', ...)
    def book_types
      @types ||= begin
        qry = Query.new(N::SourceClass).select(:type).distinct
        qry.where(:type, N::RDFS.subClassOf, N::HYPER.Material)
        qry.where(:subtype, N::RDFS.subClassOf, :type)
        qry.where(:b, N::RDF.type, :subtype)
        qry.where(:b, N::HYPER.in_catalog, self)
        qry.execute
      end
    end
    
    # returns an array containing a list of available subtypes of the given type. Of course they must
    # be present in the facsimile edition we're in
    def book_subtypes(type)
      assit_quack(type, :uri)
      @subtypes ||= {}
      @subtypes[type.to_s] ||= begin
        qry = Query.new(N::SourceClass).select(:subtype).distinct
        qry.where(:subtype, N::RDFS.subClassOf, type)
        qry.where(:b, N::RDF.type, N::TALIA.Book)
        qry.where(:b, N::RDF.type, :subtype)
        qry.where(:b, N::HYPER.in_catalog, self)        
        qry.execute
      end
    end
     
  # Returns all the books in the catalog. See elements
    def books(*types)
      types = [N::TALIA.Book] if(types.empty?)
      options = {}
      options[:sort] = true #(types == [N::TALIA.Book])
      args = types.clone
      args << options
      elements_by_type(*args)
    end 
    
    # Search for the given book and page (only the book if no page is given).
    # If the page is not given, this will return all pages of the book.
    def search(requested_book, requested_page = nil)
      return [] unless requested_book
      qry = Query.new(TaliaCore::Source).select(:p).distinct
      qry.where(:b, N::HYPER.in_catalog, self)
      qry.where(:b, N::HYPER.siglum, requested_book)
      qry.where(:p, N::DCT.isPartOf, :b)
      qry.where(:p, N::HYPER.position_name, requested_page) if(requested_page)
      qry.where(:p, N::HYPER.position, :pos)
      qry.sort(:pos)
      qry.execute 
    end
  end
end