module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class TranscriptionImporter < ContributionImporter
      
      source_type 'hyper:Transcription'
      source_class TaliaCore::HyperEdition

      def import!
        contribution_import!
      end
      
    end
  end
end
