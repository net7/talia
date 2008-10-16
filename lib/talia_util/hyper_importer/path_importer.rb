module TaliaUtil
  
  module HyperImporter
    
    # Import class for paths
    class PathImporter < ContributionImporter
      
      source_type 'hyper:Path'
      
      def import!
        contribution_import!
        add_property_from(@element_xml, 'description')
      end
      
    end
  end
end
