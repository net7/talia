module TaliaUtil
  
  module HyperImporter
    
    # Dummy import. The bibiliographical cards inside the original hyper 
    # database only contain redundant data and are ignored
    class BibliographicalCardImporter
      
      cattr_accessor :import_options
      
      def initialize(element_xml)
      end
      
      def do_import!
      end
      
      def source
      end
      
    end
  end
end
