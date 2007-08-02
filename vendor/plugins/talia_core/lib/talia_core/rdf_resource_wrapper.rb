require 'active_rdf'
require 'semantic_naming'

module TaliaCore
  
  # This extends the Resource from ActiveRDF with some functionality
  # that is needed for Talia operation
  class RdfResourceWrapper < RDFS::Resource
    
    # Wrap the accessor to get Source objects instead of RDFS::Resource
    def [](uri)
      predicate = super(uri)
      predicate = Source.new(predicate.uri) if(predicate.is_a?(RDFS::Resource))
      
      predicate
    end
    
    # Wrap the accessor to set Source objects instead of RDFS::Resourcce
    def []=(uri, value)
      value = RDFS::Resource.new(value.uri.to_s) if(value.is_a?(Source))
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
    
    # Converts an array of resources into an array of Predicates
    def convert_resource_array(resources)
      resources.collect { |r| N::Predicate.new(r.uri.to_s) } 
    end
    
  end
end