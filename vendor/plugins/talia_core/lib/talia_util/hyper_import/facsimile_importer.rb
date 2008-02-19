require 'contribution_importer'

module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class FacsimileImporter < ContributionImporter
      
      source_type 'hyper:Facsimile'
      
      def import!
        contribution_import!
        import_curators!
        add_property_from(@element_xml, "dimensionX")
        add_property_from(@element_xml, "dimensionY")
      end
      
    end
  end
end
