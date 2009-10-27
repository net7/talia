module TaliaUtil
  module EuropeanaImporter
    module EuropeanaReader

      # Load the property mapping from file
      PROPERTY_MAP = YAML::load(File.open(File.expand_path(File.join(File.dirname(__FILE__), 'property_map.yml'))))
      # Load the type mapping from file
      TYPE_MAP = YAML::load(File.open(File.expand_path(File.join(File.dirname(__FILE__), 'type_map.yml'))))

      def add_defaults
        default_properties
      end

      def default_properties
        add :uri, from_element(:europeana_uri), true
      end
      
      # Add the default class and RDF type for the given type
      def add_default_type(type)
        add :type, type
        add N::RDF.type, (N::HYPER + type)
      end

      # add a "Mapped property"
      def add_mapped(type, required = false)
        add map_property(type.to_s), from_element(type), required
      end

      # Gets the mapping from a xml element name to a property. This looks
      # up the property map; if no entry is found the default value (which
      # is the name of the element) will be used.
      def map_property(name)
        property = PROPERTY_MAP[name.to_s]
        property ||= name.underscore
        N::URI.make_uri(property, ':', N::HYPER)
      end

#      # Get a source name
#      def source_name(name)
#        if(name.blank?)
#          return name
#        else
#          return N::LOCAL + from_element(:type) + "/" + name
#        end
#      end

    end
  end
end
