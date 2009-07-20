module TaliaUtil
  
  module HyperImporter
    
    # Import class for archives.
    class ArchiveImporter < Importer
      
      source_type 'hyper:Archive'
      title_required false
      
      def import!
        add_property_from(@element_xml, "id")
        add_property_from(@element_xml, "state")
        add_property_from(@element_xml, "city")
        add_property_from(@element_xml, "address")
        add_property_from(@element_xml, "copyrightnote")
      end
      
    end
  end
end
