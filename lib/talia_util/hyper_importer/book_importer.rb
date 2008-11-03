module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class BookImporter < Importer
      
      source_type 'hyper:Book'
      
      def import!
        add_property_from(@element_xml, 'copyrightNote')
        add_property_from(@element_xml, 'description')
        add_property_from(@element_xml, 'date')
        add_property_from(@element_xml, 'collocation')
        add_property_from(@element_xml, 'publisher')
        add_property_from(@element_xml, 'publishingPlace')
        add_property_from(@element_xml, 'ordering')
        clone_to_catalog()
      end
      
      private
      
      def clone_to_catalog()
        catalog = get_catalog()
        unless catalog.nil?
          clone_uri = catalog.uri.to_s + '/' + @source.uri.local_name.to_s
          TaliaCore::Book.find(clone_uri).destroy if TaliaCore::Book.exists?(clone_uri)
          clone = catalog.add_from_concordant(@source)
        end
      end
      
    end
  end
end
