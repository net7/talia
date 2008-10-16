module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class ChapterImporter < Importer
      
      source_type 'hyper:Chapter'
      
      def import!
        add_property_from(@element_xml, 'position')
        add_property_from(@element_xml, 'name')
        add_rel_from(@element_xml, 'book')
        add_rel_from(@element_xml, 'first_page')
      end
      
      
    end
  end
end
