module TaliaUtil
  
  module HyperImporter
    
    # Import class for paths
    class EssayPageImporter < Importer
      
      source_type 'hyper:EssayPage'
      
      def import!
        add_property_from(@element_xml, 'title')
        add_property_from(@element_xml, 'position')
        add_property_from(@element_xml, 'position_name')
        import_file!
      end
      
    end
  end
end
