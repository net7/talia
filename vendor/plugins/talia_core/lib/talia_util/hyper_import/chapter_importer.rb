module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class ChapterImporter < Importer
      
      source_type 'hyper:Chapter'
      
      def import!
        import_relations!
        import_types!
        add_property_from(@element_xml, 'title', true)
        add_property_from(@element_xml, 'position')
        add_property_from(@element_xml, 'name')
        add_rel_from(@element_xml, 'first_page')
      end
      
      
    end
  end
end
