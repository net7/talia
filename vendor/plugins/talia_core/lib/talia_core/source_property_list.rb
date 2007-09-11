module TaliaCore
  
  require 'rdf_helper'
  require 'property_list_wrapper'
  
  # Contains a list of predicate values for a given predicate.
  # This will contain the values for <b>exactly one</b> predicate
  # of <b>exactly one</b> Source.
  # It can also be used as an emumeration
  class SourcePropertyList < PropertyListWrapper
    include RdfHelper
    
    protected
    
    # Convert to source
    def convert_to_mytype(resource)
      to_source(resource)
    end
    
    # Convert to resource
    def convert_to_resource(source)
      to_resource(source)
    end
  end
end