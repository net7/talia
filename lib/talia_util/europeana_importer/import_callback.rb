module TaliaUtil
  module EuropeanaImporter
    
    class ImportCallback
      
      include TaliaUtil::Progressable
      
      def before_import
        run_with_progress("Deleting previous bibliographic cards", 1) do |progress|
          # delete previous bibliographic cards
          TaliaCore::BibliographicalCard.delete_all() { progress.inc }
        end
      end
      
    end
  end
end