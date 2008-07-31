module TaliaUtil
  
  module HyperImporter
    
    # Should not be called directly, this is a superclass with common 
    # functionality for all contributions
    class ContributionImporter < Importer
      
      def import!
        assit_fail("Abstract importer, should not be called directly")
      end
      
      # This contains all the "default" import functionality for contributions
      def contribution_import!
        add_rel_from(@element_xml, 'author')
        add_property_from(@element_xml, 'publishing_date')
        add_property_from(@element_xml, 'publisher')
        add_property_from(@element_xml, 'language')
        add_property_from(@element_xml, 'alreadyPublished')
        add_property_from(@element_xml, 'curator_notes')
        import_file!
        import_authors!
      end
      
      # Import a list of curators and the curator's note for the contribution
      def import_authors!
        @element_xml.root.elements.each('authors/author') do |author|
          if(author_sig = author.text)
            author_sig = author_sig.strip
            add_source_rel(N::HYPER::author, author_sig)
          else
            assit_fail("Empty author found for #{src.uri.local_name}")
          end
        end
      end
      
    end
  end
end
