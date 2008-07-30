module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class EditionImporter < ContributionImporter
      
      source_type 'hyper:Edition'
      
      def import!
        contribution_import!
      end
      
    end
  end
end
