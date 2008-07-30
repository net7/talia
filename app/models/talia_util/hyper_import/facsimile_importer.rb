module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class FacsimileImporter < ContributionImporter
      
      source_type 'hyper:Facsimile'
      
      def import!
        contribution_import!
        add_property_from(@element_xml, "dimensionX")
        add_property_from(@element_xml, "dimensionY")
        source.hyper::dimension_units << 'pixel'
      end
      
    end
  end
end
