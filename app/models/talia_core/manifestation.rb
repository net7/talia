module TaliaCore
  
  # A manifestation is the actual digital object connected to an Expression of
  # a work and can belong to one or more AbstractExpressionCard records. 
  #
  # Usually the cards that a Realization belongs to should be concordant.
  class Manifestation < Source
    
    # The copyright note for the digital content
    def copyright_note
      # TODO: Implementation
    end
    
    # The card of the expressions of which this is a manifestation
    def expressions
      Source.find(:all, :find_through => [N::HYPER.manifestation_of, self])
    end
    
  end
  
end
