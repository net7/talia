module TaliaCore
  
  
  # This describes a concordance between multiple elements
  class Concordance < Source
    
    # Adds a concordant source to this concordance
    def add_card(new_source)
      raise(ArgumentError, "Can only add cards to a concordance.") unless(new_source.is_a?(ExpressionCard))
      predicate_set_uniq(:hyper, :concordant_to, new_source)
    end
    
    # Merge two concordances together. This will add all concordances from
    # the given on to this object and delete the other record.
    def merge(concord)
      raise(ArgumentError, "Can only merge two concordances.") unless(concord.is_a?(Concordance))
      concord.concordant_cards.each { |card| add_card(card) }
      # Delete the existing concordance
      # TODO: Warning: This deletes all "extra" things that may exist on the old concordance!
      SemanticRelation.delete_all(["subject_id = ? OR (object_type = 'TaliaCore::ActiveSource' AND object_id = ?)", concord.id, concord.id])
      Concordance.delete(concord.id)
    end
    
    # Gives all cards that are concordant to this one
    def concordant_cards
      predicate(:hyper, :concordant_to)
    end
    
  end
  
end
