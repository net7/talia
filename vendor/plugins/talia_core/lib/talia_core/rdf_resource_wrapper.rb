module TaliaCore
  
  require 'active_rdf'
  
  # This extends the Resource from ActiveRDF with some functionality
  # that is needed for Talia operation
  class RdfResourceWrapper < RDFS::Resource
    
    # Wrap the accessor to get Source objects instead of
    # RDFS::Resource
    def [](uri)
      predicate = super(uri)
      if(predicate.is_a?(RDFS::Resource))
        predicate = Source.new(predicate.uri)
      end
      
      return predicate
    end
    
    # Wrap the accessor to set Source objects instead of
    # RDFS::Resourcce
    def []=(uri, value)
      if(value.is_a?(Source))
        value = RDFS::Resource.new(value.uri.to_s)
      end
      super(uri, value)
    end
    
  end
end