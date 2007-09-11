module TaliaCore
  
  # This wraps an ActiveRDF property list. The main function is to 
  # transparently convert RDFS::Resource objects in the list to another
  # type. This type will determined by the subclasses, this class is
  # only an abstract superclass.
  class PropertyListWrapper
    
    # make this enumerable
    include Enumerable
    
    # Create a new list for the given predicate and source.
    # This will also connect a connection to the RDF store
    # for the predicate list.
    # 
    # The subclass will need to supply the convert_to_mytype
    # and convert_to_resource methods
    def initialize(prop_list)
      sassert_type(prop_list, PropertyList)
      
      @rdf_list = prop_list
    end
    
    # Adds a new value to the list and hence to the RDF store.
    def <<(pv)
      pv = convert_to_resource(pv)
      @rdf_list << pv
    end
    
    # Delete the predicate statement with the old value, and
    # replace it with the new value. This is equivalent to
    # exchanging an element in the list.
    def []=(old_p_value, new_p_value)
      old_p_value = convert_to_resource(old_p_value)
      new_p_value = convert_to_resource(new_p_value)
      
      @rdf_list[old_p_value] = new_p_value
    end
    
    # Remove elements from the list. If no parameter is given,
    # all elements will be removed. If parameters are given,
    # the elements with the given values are removed.
    def remove(*params)
      params = params.collect { |param| convert_to_resource(param) }
      @rdf_list.remove(*params)
    end
    
    #  Gets an element from the list
    def [](index)
      convert_to_mytype(@rdf_list[index])
    end
    
    # Call for each element of the underlying RDF store,
    # elements will be converted to Source objects, if neccessary
    def each(&block)
      @rdf_list.each do |pv|
        block.call(convert_to_mytype(pv))
      end
    end
    
    # Compare predicate lists. Lists are equal if they contain the
    # same elements, and the predicate list is also equal to an
    # array with the same elements
    def ==(object)
      equal = false
      if(object.kind_of?(Array) || object.kind_of?(self.class))
        # either compares arrays, or compares the Predicate List with the internal array
        equal = (object == @rdf_list) 
      end
      equal
    end
    
    # Size of the list
    def size
      @rdf_list.size
    end
    
  end
  
end