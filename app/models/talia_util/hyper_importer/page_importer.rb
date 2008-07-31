module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class PageImporter < Importer
      
      source_type 'hyper:Page'
      
      def import!
        add_property_from(@element_xml, 'width')
        add_property_from(@element_xml, 'height')
        add_property_from(@element_xml, 'position')
        add_property_from(@element_xml, 'position_name')
        source.hyper::dimension_units << 'pixel'
      end
      
    end
  end
end
