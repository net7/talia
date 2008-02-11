module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class EditionImporter < Importer
      
      source_type 'hyper:Edition'
      
      def import!
        import_relations!
        import_types!
        add_property_from(@element_xml, 'title', true)
        add_property_from(@element_xml, 'publishing_date')
        add_property_from(@element_xml, 'publisher')
        add_property_from(@element_xml, 'language')
        add_property_from(@element_xml, 'alreadyPublished')
        add_property_from(@element_xml, 'curator_notes')
        import_curators
        import_file!
      end
      
      def import_curators
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
