require 'rdf_helper'
require 'active_rdf'
require 'semantic_naming'

module TaliaCore
  
  # This extends the Resource from ActiveRDF with some functionality
  # that is needed for Talia operation
  class RdfResourceWrapper < RDFS::Resource
    include RdfHelper
    
    # Creates an alias for the array accessor of the superclass,
    # for the use in the following methods
    alias_method :arr_access, "[]"
    
    # Wrap the accessor to get SourcePropertyList objects instead of PropertyList
    def [](predicate)
      prop_list = arr_access(predicate.to_s)
      SourcePropertyList.new(prop_list)
    end
    
    # Converts the predicates into a URIs (instead of RDFS::Resource)
    def direct_predicates()
      to_predicates(super)
    end
    
    # Converts the class-level predicates
    def class_level_predicates()
      to_predicates(super)
    end
    
  end
end