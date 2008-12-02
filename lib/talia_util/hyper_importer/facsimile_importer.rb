module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class FacsimileImporter < ContributionImporter
      
      source_type 'hyper:Facsimile'
      
      def import!
        contribution_import!
        import_dimensions!
      end
      
      # Import the dimensions
      def import_dimensions!
        width = @element_xml.elements['dimensionX']
        height = @element_xml.elements['dimensionY']
        if(width.text && height.text)
          quick_add_predicate(source, N::DCT.extent, "#{width.text.strip}x#{height.text.strip} pixel")
        end
      end
      
    end
  end
end
