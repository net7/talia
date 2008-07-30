module TaliaUtil
  
  module HyperImporter
    
    # Import class for paragraphs
    class PathStepImporter < Importer
      
      source_type 'hyper:PathStep'
      title_required false
      
      def import!
        add_property_from(@element_xml, "stepDescription")
        add_property_from(@element_xml, "position")
      end
      
    end
  end
end
