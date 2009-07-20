module TaliaCore

  # This is a single item in a semantic collection wrapper. The contents are
  #  * fat_relation - a SemanticRelation with all the columns needed to build the
  #    related objects
  #  * plain_relation - a normal semantic relation object (either this or fat_relation)
  #    should be given
  # Only one of the above should be usually given
  class SemanticCollectionItem

    attr_reader :plain_relation, :fat_relation

    def initialize(relation, plain_or_fat)
      case plain_or_fat
      when :plain
        @plain_relation = relation
      when :fat
        @fat_relation = relation
      else
        raise(ArgumentError, "Unknown type")
      end
      @object_type = SemanticCollectionWrapper.special_types[relation.predicate_uri.to_s]
    end

    # Return the relation object that was given
    def relation
      @fat_relation || @plain_relation
    end

    # Return the "value" (Semantic relation value or the related ActiveSource)
    def value
      semprop = object.is_a?(SemanticProperty)
      if(@object_type)
        assit(object, "Must have object for #{relation.predicate_uri}")
        raise(ArgumentError, 'Must not have a property for a typed item') if(semprop)
        @object_type.new(object.uri.to_s)
      else
        # Plain, return the object or the value for SemanticProperties
        semprop ? object.value : object
      end
    end

    # Creates an object from the given relation
    def object
      @object ||= begin
        if(@fat_relation)
          create_object_from(@fat_relation)
        elsif(@plain_relation)
          @plain_relation.object
        else
          raise(ArgumentError, "No relation was given to this object")
        end
      end
    end

    def ==(compare)
      self.value == compare
    end

    # if the object is a relation, it will r

    # Creates an object frm the given "fat" relation. This retrieves the data
    # from the relation object and instantiates it just like it would be after
    # a find operation.
    def create_object_from(fat_relation)
      # First we find out which class (table our target object is in)
      klass = fat_relation.object_type.constantize
      record = nil
      if(klass == TaliaCore::ActiveSource)
        # We prepare a hash of properties for the ActiveSource
        record = {
          'uri' => fat_relation.object_uri,
          'created_at' => fat_relation.object_created_at,
          'updated_at' => fat_relation.object_updated_at,
          'type' => fat_relation.object_realtype
        }
      elsif(klass == TaliaCore::SemanticProperty)
        # We prepare a hash of properties for the SemanticProperty
        record = {
          'value' => fat_relation.property_value,
          'created_at' => fat_relation.property_created_at,
          'updated_at' => fat_relation.property_updated_at
        }
      end
      # Common attributes
      record['id'] = fat_relation.object_id
      # Instantiate the new record
      klass.send(:instantiate, record)
    end

  end

end
