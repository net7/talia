module TaliaCore
  class SemanticRelation < ActiveRecord::Base
    belongs_to :subject, :class_name => 'ActiveSource'
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

    class << self

      # Retrieve "fat" relations for the given source and property
      def find_fat_relations(source, predicate)
        joins = ActiveSource.sources_join
        joins << ActiveSource.props_join
        relations = SemanticRelation.find(:all, :conditions => {
            :subject_id => source.id,
            :predicate_uri => predicate
          },
          :joins => joins,
          :select => fat_record_select
        )
        relations
      end

      # For selecting "fat" records on the semantic properties
      def fat_record_select
        @select ||= begin
          select = 'semantic_relations.id AS id, semantic_relations.created_at AS created_at, '
          select << 'semantic_relations.updated_at AS updated_at, '
          select << 'semantic_relations.rel_order AS rel_order,'
          select << 'object_id, object_type, subject_id, predicate_uri, '
          select << 'obj_props.created_at AS property_created_at, '
          select << 'obj_props.updated_at AS property_updated_at, '
          select << 'obj_props.value AS property_value, '
          select << 'obj_sources.created_at AS object_created_at, '
          select << 'obj_sources.updated_at AS object_updated_at, obj_sources.type AS  object_realtype, '
          select << 'obj_sources.uri AS object_uri'
          select
        end
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
