module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class BookImporter < Importer
      
      source_type 'hyper:Book'
      
      # TODO: Still missing import for contained NOTES elements
      def import!
        import_relations!
        import_types!
        add_property_from(@element_xml, 'title', true)
        add_property_from(@element_xml, 'copyrightNote')
        add_property_from(@element_xml, 'description')
        add_property_from(@element_xml, 'date')
        add_property_from(@element_xml, 'collocation')
        add_property_from(@element_xml, 'publisher')
        add_property_from(@element_xml, 'publishingPlace')
        add_property_from(@element_xml, 'ordering')
      end
      
      
    end
  end
end
