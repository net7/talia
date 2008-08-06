module TaliaCore 
  class FacsimileEdition < Catalog
    # returns an array containing a list of the book types available and connected to this facsimile edition
    # (e.g.: 'Works', 'Manuscripts', ...)
    def book_types
      @types ||= begin
        qry = Query.new(N::SourceClass).select(:type).distinct
        #FIXME: the next two lines were here.
        # Didn't manage to check for the presence of types in the Onotolgy and 
        # if they equal the ones used in the RDF for storage
        #                qry.where(:t, N::RDFS.subClassOf, N::HYPER.Material)
        # There isn't something like N::HYPER.usedType in the RDF, yet
        # I substituted it with the lines below
        #        qry.where(self, N::HYPER.usedType, :t)
        qry.where(:book, N::RDF.type, N::TALIA.Book)
        qry.where(:book, N::HYPER.in_catalog, self)        
        qry.where(:book, N::HYPER.type, :type)
        qry.execute
      end
    end
    
    # returns an array containing a list of available subtypes of the given type. Of course they must
    # be present in the facsimile edition we're in
    def book_subtypes(type)
      #      assit_quack(type, :uri)
      @subtypes ||= {}
      @subtypes[type.to_s] ||= begin
        qry = Query.new(N::SourceClass).select(:t).distinct
        #        qry.where(:t, N::RDFS.subClassOf, type)
        #        qry.where(self, N::HYPER.usedType, :t)
        qry.where(:b, N::RDF.type, N::TALIA.Book)
        qry.where(:b, N::HYPER.in_catalog, self)        
        qry.where(:b, N::HYPER.subtype, :t)
        qry.where(:b, N::HYPER.type, type)
        qry.execute
      end
    end
    
    # Returns an array containing a list of all the elements of the given type 
    # (manuscripts, works, etc.). Types can also contain subtypes (notebook, draft, etc.) 
    # 
    # The types should be a list of N::URI elements indicating the RDF classes.
    def elements_by_type(*types)
      qry = Query.new(TaliaCore::Source).select(:element).distinct
      types.each do |type|
        # I've found manuscripts, notebook, etc as plain text in the RDF, they don't 
        # pass the quack test below
        #        assit_quack(type, :uri)
        if (type.is_a?(N::URI))
          qry.where(:element, N::RDF.type, type)
        else
          # very ugly but we've added 'manuscripts', 'copybook', etc. just like that (without an URI)
          qry.where(:element, N::HYPER.type, type)
     #TODO: the type may actually be found in the N::HYPER.subtype predicate, we'd need an OR here...

        end
      end
      qry.where(:element, N::HYPER.in_catalog, self)
      qry.execute
    end
    
    # Returns all the books in the catalog. See elements
    def books(*types)
      #FIXME: I load the TaliaCore::Book class so the elements method will return 
      # proper objects
      TaliaCore::Book
      types << N::TALIA.Book
      elements_by_type(*types)
    end
    
    # Search for the given book and page (only the book if no page is given).
    # If the page is not given, this will return all pages of the book.
    def search(requested_book, requested_page = nil)
        return [] unless requested_book
      qry = Query.new(TaliaCore::Source).select(:p).distinct
      qry.where(:b, N::HYPER.in_catalog, self)
      qry.where(:b, N::HYPER.siglum, requested_book)
      qry.where(:p, N::HYPER.part_of, :b)
      qry.where(:p, N::HYPER.position_name, requested_page) if(requested_page)
      qry.where(:p, N::HYPER.position, :pos)
      qry.sort(:pos)
      qry.execute 
    end

    
  end
end