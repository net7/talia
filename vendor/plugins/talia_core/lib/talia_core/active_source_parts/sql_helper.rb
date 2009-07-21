module TaliaCore
  module ActiveSourceParts
    
    # This contains sql joins and segments that can be used by the ActiveSource classes.
    module SqlHelper
      
      # Returns the "default" join (meaning that it joins all the "triple tables"
      # together. The flags signal whether the relations and properties should 
      # be joined.
      def default_joins(include_rels = true, include_props = true)
        join = "LEFT JOIN semantic_relations ON semantic_relations.subject_id = active_sources.id "
        join << sources_join if(include_rels)
        join << props_join  if(include_props)
        join
      end

      # Joins sources on semantic relations
      def sources_join
        " LEFT JOIN active_sources AS obj_sources ON semantic_relations.object_id = obj_sources.id AND semantic_relations.object_type = 'TaliaCore::ActiveSource'"
      end

      # Joins properties on semantic relations
      def props_join
        " LEFT JOIN semantic_properties AS obj_props ON semantic_relations.object_id = obj_props.id AND semantic_relations.object_type = 'TaliaCore::SemanticProperty'"
      end

      # Returns the "default" join for reverse lookups
      def default_inv_joins
        join = "LEFT JOIN semantic_relations ON semantic_relations.object_id = active_sources.id AND semantic_relations.object_type = 'TaliaCore::ActiveSource' "
        join << " LEFT JOIN active_sources AS sub_sources ON semantic_relations.subject_id = sub_sources.id"
        join
      end
      
    end
  end
end