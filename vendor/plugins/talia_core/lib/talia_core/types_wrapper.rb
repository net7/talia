module TaliaCore
  
  # This wraps the "types" (that are stored as ActiveSources) into 
  # N::SourceClass objects and otherwise behaves as the base class
  class TypesWrapper < SemanticCollectionWrapper
    
    # Initialize the list
    def initialize(collection, source, predicate)
      @assoc_source = source
      @assoc_predicate = predicate.to_s
      # Add the collection to self, converting everything into N::SourceClass.
      # All elements are expected to be ActiveSources
      collection.each { |t| self.push(to_type(t)) }
    end
    
    private
    
    # Acts like the superclass, only that the value is always interpreted as a 
    # type URI
    def get_relation_for(value)
      value = N::SourceClass.new(value)
      super(to_type_source(value))
    end
    
    # Adds a new relation to the type that is represented by the given URL.
    # Note that the db record for the type must already exist
    def add_record_for(value)
      value = value.uri if(value.respond_to?(:uri))
      value = N::SourceClass.new(value)
      add_db_record_for(to_type_source(value))
      self.push(value)
    end
    
    # Finds the ActiveSource matching the given uri.
    def to_type_source(value)
      uri = (value.respond_to?(:uri)) ? value.uri : value
      unless(value.is_a?(ActiveSource))
        value = ActiveSource.find(:first, :conditions => { :uri => uri } )
        value ||= ActiveSource.new(uri) # Create new type if there's none
        raise(ActiveRecord::RecordNotFound, "No record for uri '#{uri}'") unless(value)
      end
      value
    end
    
    # Returns a SourceClass object for the uri of the ActiveSource record given.
    def to_type(source)
      if(source.is_a?(ActiveSource))
        N::SourceClass.new(source.uri)
      else
        raise(ArgumentError("Type list shouldn't contain a property"))
      end
    end
    
  end
  
end
