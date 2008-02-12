module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class EssayImporter < ContributionImporter
      
      source_type 'hyper:Essay'
      
      def import!
        contribution_import!
        import_curators!
        add_rel_from(@element_xml, "abstract")
      end
      
    end
  end
end
