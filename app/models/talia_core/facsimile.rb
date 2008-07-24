module TaliaCore
  
  # This represents a facsimile in the system (wich is usually the picture
  # of a single page)
  class Facsimile < Manifestation
    
    # The IIP path (identifier) that the IIP frontend uses to display the
    # facsimile
    def iip_path
      # TODO: Impelementation
    end
    
    # Returns the thumbnail ("minifax") of this element
    def thumb
      # TODO: Implementation
    end
    
  end
end
