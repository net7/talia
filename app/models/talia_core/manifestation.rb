module TaliaCore
  
  # A manifestation is the actual digital object connected to an Expression of
  # a work and can belong to one or more ExpressionCard records. 
  #
  # Usually the cards that a Realization belongs to should be concordant.
  class Manifestation < Source
    
    # The copyright note for the digital content
    def copyright_note
      # TODO: Implementation
    end
    
    # to be used by the feeder, this is the common one, some subclasses (like HyperEditions) 
    # will have a specialization for it
    def available_versions
      versions = ['standard']
    end
    
    
    # The card of the expressions of which this is a manifestation
    def expressions      
      #      Source.find(:all, :find_through => [N::HYPER.manifestation_of, self])
      qry = Query.new(TaliaCore::Source).select(:s).distinct
      qry.where(self, N::HYPER.manifestation_of, :s)
      qry.execute
    end
    
  end
  
end
