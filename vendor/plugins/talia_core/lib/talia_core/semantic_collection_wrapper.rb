module TaliaCore
  
  # Wraps the Array/Collection returned from the ActiveRecord, simply 
  # "hiding" the SemanticProperty objects behind strings.
  class SemanticCollectionWrapper < Array
    
    # Initialize the list
    def initialize(collection, source, predicate)
      # raise(ActiveRecord::RecordNotSaved, "No properties on unsaved record.") if(source.new_record?)
      @assoc_source = source
      @assoc_predicate = predicate.to_s
      # Add the properties to self, converting Semantic properties to 
      # Strings
      collection.each do |thing|
        if(thing.is_a?(SemanticProperty))
          self.push(thing.value)
        else
          self.push(thing)
        end
      end
    end
  
    # Push to collection. Giving a string will create a property to be created,
    # saved and associated.
    def <<(value)
      if(value.kind_of?(Array))
        value.each { |v| add_record_for(v) }
      else
        add_record_for(value)
      end
    end
    alias_method :concat, '<<'
    
    # Replace a value with a new one
    def replace(old_value, new_value)
      remove_relation(old_value)
      add_record_for(new_value)
    end
    
    # Remove the given value. With no parameters, the whole list will be
    # cleared
    def remove(*params)
      if(params.length > 0)
        params.each { |par| remove_relation(par) }
      else
        @assoc_source.semantic_relations.destroy_all(:predicate_url => @assoc_predicate)
      end
    end
    
    private
    
    # Deletes the relation where with the current predicate and the given 
    # value.
    def remove_relation(value)
      if(relation = get_relation_for(value))
        @assoc_source.semantic_relations.delete(relation)
      end
      self.delete(value)
    end
    
    # Retrieve the "original" record for the given element. This means that
    # it will search the database for a related element with the given value.
    # If the value is already a db record, it will just be returned.
    def get_relation_for(value)
      # Finding we want to select the right relation from the join table
      # that has the "correct" predicate_url and where the associated object
      # matches the given value. This needs a little join...
      if(value.is_a?(ActiveSource))
        @assoc_source.semantic_relations.find(:first,
          :joins => 'LEFT JOIN active_sources ON object_id = active_sources.id',
          :conditions => {
            :object_type => 'TaliaCore::ActiveSource',
            :predicate_uri => @assoc_predicate,
            'active_sources.uri' => value.uri.to_s
          })
      else
        @assoc_source.semantic_relations.find(:first, 
          :joins => 'LEFT JOIN semantic_properties ON object_id = semantic_properties.id',
          :conditions => {
            :object_type => 'TaliaCore::SemanticProperty',
            :predicate_uri => @assoc_predicate,
            'semantic_properties.value' => value.to_s
          })
      end
    end
    
    # Creates a record for a value and adds it. This will add the given value if it's 
    # a database record and otherwise create a property with the given value
    def add_record_for(value)
      add_db_record_for(value)
      value = value.value if(value.is_a?(SemanticProperty))
      self.push(value)
    end
   

    # This actually creates a new relation record in the db
    def add_db_record_for(value)
      # We need to manually create the relation, to add the predicate_url
      to_add = SemanticRelation.new
      to_add.predicate_uri = @assoc_predicate
      if(value.is_a?(ActiveSource) || value.is_a?(SemanticProperty))
        to_add.object = value
      else
        prop = SemanticProperty.new
        prop.value = value
        to_add.object = prop
      end
      @assoc_source.semantic_relations << to_add
    end
    
  end
  
end
