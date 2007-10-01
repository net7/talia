module TaliaCore
  
  # This represents the types of a Source object. Each TypeList is 
  # bound to one Source object and the 
  class TypeList

    # make this enumerable
    include Enumerable
    
    # Create a new type list. This is passed a list 
    def initialize(type_records)
      @type_records = type_records
    end
    
    # Adds a type to the list
    def <<(type)
      @type_records << TypeRecord.new(type.to_s)
    end
    
    # Replace the given type
    def []=(old_type, new_type)
      @type_records.delete(TypeRecord.new(old_type.to_s))
      @type_records << TypeRecord.new(new_type.to_s)
    end
    
    # Remove elements from the list. If no parameter is given,
    # all elements will be removed. If parameters are given,
    # the elements with the given values are removed.
    def remove(*params)
      params = params.collect { |param| TypeRecord.new(param.to_s) }
      @type_records.delete(*params)
    end
    
    #  Gets an element from the list
    def [](index)
      N::SourceClass.new(@type_records[index].uri)
    end
    
    # Call for each element of the underlying RDF store,
    # elements will be converted to Source objects, if neccessary
    def each(&block)
      @type_records.each do |record|
        block.call(N::SourceClass.new(record.uri))
      end
    end
    
    # Compare predicate lists. Lists are equal if they contain the
    # same elements, and the predicate list is also equal to an
    # array with the same elements
    def ==(object)
      equal = false
      if(object.kind_of?(Array) || object.kind_of?(self.class))
        # either compares arrays, or compares the Predicate List with the internal array
        equal = (object == @type_records) 
      end
      equal
    end
    
    # Size of the list
    def size
      @type_records.size
    end
  end
end