require 'rdf_helper'
require 'active_rdf'
require 'semantic_naming'

module TaliaCore
  
  # This extends the Resource from ActiveRDF with some functionality
  # that is needed for Talia operation
  class RdfResourceWrapper < RDFS::Resource
    include RdfHelper
    
    # Class methods
    class << self
      # load the helpers for static methods
      include RdfHelper
      
      # Queries the RDF store with a query that is built from the given
      # hash.
      #
      # The hash can contain the following special keys:
      # * :limit - Limits the result set to the given number of elements
      # * :offset - Sets the first element that will be returned by the query
      #
      # ALL other elements will be regarded as key/value pairs of predicates and values. 
      # The query will be built so that it will only return elements for which the predicate
      # has the given value. These is equivalent to a boolean AND.
      #
      # This will return the "raw" result of the query, which is usually strings and/or
      # RDFS
      def find_from_hash(option_hash = {})
        sassert_type(option_hash, Hash)
        
        limit = option_hash.delete(:limit)
        offset = option_hash.delete(:offset)
        
        # Check for type entry
        type = option_hash.delete(:type)
        option_hash[N::RDFS + "Class"] = RDFS::Resource.new(type.to_s) if(type)
        
        qry = Query.new.select(:s).where(:s, :p, :o).distinct
        
        option_hash.each do |key, value|
          qry.where(:s, RDFS::Resource.new(key.to_s), to_resource(value))
        end
        
        qry.limit(limit.to_i) if(limit)
        qry.offset(offset.to_i) if(offset)
        
        qry.execute
      end
      
    end
    
    # Creates an alias for the array accessor of the superclass,
    # for the use in the following methods
    alias_method :arr_access, "[]"
    
    # Wrap the accessor to get SourcePropertyList objects instead of PropertyList
    def [](predicate)
      prop_list = arr_access(predicate.to_s)
      SourcePropertyList.new(prop_list)
    end
    
    # This returns the type information from the resource. Instead of
    # a PredicateList this will return a TypeList.
    #
    # Types will be stored as N::RDFS::Class, which means that this
    # method won't work before the initializer is run.
    def types
      type_list = arr_access((N::RDFS + "Class").to_s)
      TypeList.new(type_list)
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