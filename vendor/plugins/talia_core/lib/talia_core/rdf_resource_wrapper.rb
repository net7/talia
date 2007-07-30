module TaliaCore
  
  require 'active_rdf'
  require 'semantic_naming'
  
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
    
    # Converts the predicates into a URIs (instead of RDFS::Resource)
    def direct_predicates()
      convert_resource_array(super)
    end
    
    # Converts the class-level predicates
    def class_level_predicates()
      convert_resource_array(super)
    end
    
    protected
    
    # Converts an array of resources into an array of 
    # Predicates
    def convert_resource_array(resources)
      uris = Array.new
      
      for resource in resources do
        uris.push(N::Predicate.new(resource.uri.to_s))
      end
      
      uris
    end
    
  end
end