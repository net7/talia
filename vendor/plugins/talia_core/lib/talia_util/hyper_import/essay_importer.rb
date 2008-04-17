module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class EssayImporter < ContributionImporter
      
      source_type 'hyper:Essay'
      
      def import!
        contribution_import!
        add_property_from(@element_xml, "abstract")
      end
      
    end
  end
end
