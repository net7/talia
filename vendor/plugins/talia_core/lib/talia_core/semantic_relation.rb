module TaliaCore
  class SemanticRelation < ActiveRecord::Base
    belongs_to :subject, :class_name => 'ActiveSource'
    belongs_to :object, :polymorphic => true
    before_destroy :discard_property
    
    private
    
    # Discards the "value" property that belongs to this source
    def discard_property
      if(object.is_a?(SemanticProperty))
        SemanticProperty.delete(object.id)
      end
    end
  end
end
