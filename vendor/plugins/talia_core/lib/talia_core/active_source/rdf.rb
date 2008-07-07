module TaliaCore
  class ActiveSource < ActiveRecord::Base
  # This file contains the RDF handling elements of the ActiveSource class

    # Handler for creating the rdf
    after_save :create_rdf
    
    # Returns the RDF object to use for this ActiveSource
    def rdf
      @rdf_resource ||= begin
        src =RdfResource.new(uri)
        src.object_class = TaliaCore::ActiveSource
        src
      end
    end
    
    private
    
    # This creates the RDF subgraph for this Source and saves it to disk. This
    # may be an expensive operation since it removes the existing elements.
    # (Could be optimised ;-)
    def create_rdf
      # First remove all data on this
      rdf.direct_predicates do |pred|
        rdf[pred].remove
      end
      # Now create the new RDF subgraph
      semantic_relations.each do |sem_ref|
        # We pass the object on. If it's a SemanticProperty, we need to add
        # the value. If not the RDF handler will detect the #uri method and
        # will add it as Resource.
        obj = sem_ref.object
        value = obj.is_a?(SemanticProperty) ? obj.value : obj
        rdf[sem_ref.predicate_uri] << value
      end
      rdf.save
    end
    
  end
end
