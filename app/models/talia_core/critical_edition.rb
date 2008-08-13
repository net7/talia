module TaliaCore 
  class CriticalEdition < Catalog
    
    # Prefix for edition URIS
    EDITION_PREFIX = 'critical_editions'
    
    # returns an array containing a list of all the books of the given type 
    # (manuscripts, works, etc.) or subtype (notebook, draft, etc.) belonging 
    # to this CRITICAL Edition. Books of a subtype also belong to the type
    # of which it is a subtype.
   # Returns all the books in the catalog. See elements
    def books
      types << N::TALIA.Book
      elements_by_type(*types)
    end
  end
end