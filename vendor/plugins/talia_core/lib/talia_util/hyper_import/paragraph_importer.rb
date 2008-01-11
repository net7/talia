module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class ParagraphImporter < Importer
      
      # TODO: Still missing import for contained NOTES elements
      def import!
        import_relations!
        @source[N::DCNS::title] << get_text(@element_xml, "title")
        type_name = get_text(@element_xml, "type")
        @source.types << N::HY_NIETZSCHE + type_name
      end
      
    end
    
  end
  
end
