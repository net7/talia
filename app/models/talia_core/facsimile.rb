module TaliaCore
  
  # This represents a facsimile in the system (wich is usually the picture
  # of a single page)
  class Facsimile < Manifestation
    
    singular_property :dimensions, N::DCT.extent
        
    # The IIP path (identifier) that the IIP frontend uses to display the
    # facsimile
    def iip_path
      # TODO: Implementation
    end
    
    # Returns the thumbnail ("minifax") of this element
    def thumb
      # TODO: Implementation
      # the views wait for something like:
      # send_data image.content_string, :type => 'image/jpeg', :disposition => 'inline'
    end
    
  end
end
