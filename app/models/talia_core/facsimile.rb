module TaliaCore
  
  # This represents a facsimile in the system (wich is usually the picture
  # of a single page)
  class Facsimile < Manifestation
    
    singular_property :dimensions, N::DCT.extent
    singular_property :blank, N::HYPER.blank_facsimile # If it's blank page without iip/image data
        
    # Return the IipData object if it exists. Nil otherwise.
    def iip_data
      data_records.find(:first, :conditions => {:type => 'IipData'})
    end

    # Return the Original image object if it exists. Nil otherwise
    def original_image
      data_records.find(:first, :conditions => {:type => 'ImageData'})
    end
    
    # Return the pdf data if it exists, or nil otherwise
    def pdf_data
      data_records.find(:first, :conditions => {:type => 'PdfData'})
    end
    
  end
end
