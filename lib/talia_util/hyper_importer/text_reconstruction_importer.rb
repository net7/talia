module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class TextReconstructionImporter < ContributionImporter

      source_type 'hyper:HyperEdition'
      source_class TaliaCore::TextReconstruction
      
      def import!
        contribution_import!
      end
      
    end
  end
end
