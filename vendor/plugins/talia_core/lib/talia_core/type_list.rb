module TaliaCore
  
  require 'property_list_wrapper'
  
  # This is a wrapper for an ActiveRDF property list, where
  # each property represents an RDF type (which is represneted by an
  # SourceClass object).
  class TypeList < PropertyListWrapper

    protected
    
    # Convert to source
    def convert_to_mytype(resource)
      type_uri = (resource.is_a?(RDFS::Resource)) ? resource.uri : resource.to_s
      N::SourceClass.new(type_uri)
    end
    
    # Convert to resource
    def convert_to_resource(uri)
      RDFS::Resource.new(uri.to_s)
    end
  end
end