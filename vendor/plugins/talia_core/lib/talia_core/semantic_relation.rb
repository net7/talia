module TaliaCore
  class SemanticRelation < ActiveRecord::Base
    belongs_to :subject, :class_name => 'TaliaCore::ActiveSource'
    belongs_to :object, :polymorphic => true
    before_destroy :discard_property

    # Returns true if the Relation matches the given predicate URI (and value,
    # if given)
    def matches?(predicate, value = nil)
      if(value)
        if(value.is_a?(ActiveSource) || value.is_a?(SemanticProperty))
          (predicate_uri == predicate.to_s) && (value == object)
        else
          return false unless(object.is_a?(SemanticProperty))
          (predicate_uri == predicate.to_s) && (object.value == value)
        end
      else
        predicate_uri == predicate.to_s
      end
    end

    private
    
    # Discards the "value" property that belongs to this source
    def discard_property
      if(object.is_a?(SemanticProperty))
        SemanticProperty.delete(object.id)
      end
    end

  end
end
