module TaliaUtil
  
  module HyperImporter
    
    # Import class for paths
    class ExternalObjectImporter < ContributionImporter
      
      source_type 'hyper:ExternalObject'
      
      def import!
        contribution_import!
        add_property_from(@element_xml, 'description')
        add_property_from(@element_xml, 'publication_place')
        add_property_from(@element_xml, 'first_page')
        add_property_from(@element_xml, 'last_page')
        add_property_from(@element_xml, 'journal')
        add_property_from(@element_xml, 'book_collection')
        add_property_from(@element_xml, 'pages')
        add_rel_from(@element_xml, 'related_contribution')
      end
      
    end
  end
end
