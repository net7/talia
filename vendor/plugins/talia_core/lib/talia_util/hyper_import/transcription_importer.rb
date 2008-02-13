module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class TranscriptionImporter < ContributionImporter
      
      source_type 'hyper:Transcription'
      
      def import!
        contribution_import!
        import_curators!
      end
      
    end
  end
end
