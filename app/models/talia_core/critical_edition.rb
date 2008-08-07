module TaliaCore 
  class CriticalEdition < Catalog
    
    # Prefix for edition URIS
    EDITION_PREFIX = 'critical_editions'
    
    # returns an array containing a list of all the books of the given type 
    # (manuscripts, works, etc.) or subtype (notebook, draft, etc.) belonging 
    # to this CRITICAL Edition. Books of a subtype also belong to the type
    # of which it is a subtype.
    def books(type = nil)
      assit_quack(type, :uri) if(type)
      qry = Query.new(TaliaCore::Source).select(:b).distinct
      qry.where(:b, N::RDF.type, type) if(type)
      qry.where(:b, N::HYPER.in_catalog, self)
      qry.execute
    end
  end
end