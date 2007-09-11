module TaliaCore
  # Helper mixin for RDF-related functionality
  module RdfHelper
   
    # Convert from Source to RDFS::Resource.
    # This does nothing if the parameter is not of the given from_type
    def to_resource(source)
      source.is_a?(TaliaCore::Source) ? RDFS::Resource.new(source.uri.to_s) : source
    end
    
    # Convert from RDFS::Resource to Source
    # This does nothing if the parameter is not a RDFS::Resource
    def to_source(resource)
      resource.kind_of?(RDFS::Resource) ? TaliaCore::Source.new(resource.uri) : resource
    end

    # Converts an array of RDFS::Resource objects to N::Predicate
    def to_predicates(resources)
      resources.collect { |r| N::Predicate.new(r.uri.to_s) } 
    end
    
    # Converts an array of RDFS::Resource objects to TaliaCore::Source
    def to_sources(resources)
      resources.collect { |r| TaliaCore::Source.new(r.uri.to_s) } 
    end
  end
end