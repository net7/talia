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
        import_file!
      end
      
      # Import a list of curators and the curator's note for the contribution
      def import_curators!
        add_property_from(@element_xml, 'curator_notes')
        @element_xml.root.elements.each('curators/curator') do |curator|
          if(curator_sig = curator.text)
            curator_sig = curator_sig.strip
            add_source_rel(N::HYPER::curator, curator_sig)
          else
            assit_fail("Empty curator found for #{src.uri.local_name}")
          end
        end
      end
      
    end
  end
end
