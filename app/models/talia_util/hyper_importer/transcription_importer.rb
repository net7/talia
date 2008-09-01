module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class TranscriptionImporter < ContributionImporter
      
      source_type 'hyper:HyperEdition'
      source_class TaliaCore::Transcription

      def import!
        contribution_import!
      end
      
    end
  end
end
