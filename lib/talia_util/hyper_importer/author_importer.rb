module TaliaUtil
  
  module HyperImporter
    
    # Import class for authors
    class AuthorImporter < Importer
      
      source_type 'hyper:Author'
      source_class TaliaCore::Person
      title_required false
      
      def import!
        add_author_property('name')
        add_author_property('surname')
        add_author_property('status')
        add_author_property('institution')
        add_property_from(@element_xml, 'position')
        add_property_from(@element_xml, 'street')
        add_property_from(@element_xml, 'zip')
        add_property_from(@element_xml, 'city')
        add_property_from(@element_xml, 'country')
        add_property_from(@element_xml, 'telephone')
        add_property_from(@element_xml, 'fax')
        add_property_from(@element_xml, 'email')
        add_property_from(@element_xml, 'webpage')
        add_property_from(@element_xml, 'from_date')
        add_property_from(@element_xml, 'to_date')
      end
      
      private
      
      def add_author_property(property)
        add_property_explicit(@element_xml, property, N::HYPER + ('author_' << property))
      end
      
    end
  end
end
