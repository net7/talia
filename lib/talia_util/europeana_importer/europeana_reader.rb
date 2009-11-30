require 'digest/sha1'

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
        add :uri, source_name, true
      end
      
      # Add the default class and RDF type for the given type
      def add_default_type(type)
        add :type, type
        add N::RDF.type, (N::HYPER + type)
      end

      def add_is_shown_by()
        is_shown_by = from_element(:is_shown_by)

        unless (is_shown_by == '' || is_shown_by.nil?)

          if is_shown_by.match('facsimiles')
            is_shown_by = is_shown_by + '.jpeg?size=thumb'
          end

          add  N::HYPER.isShownBy, is_shown_by
        end
      end

      # add a "Mapped property"
      def add_mapped(type, required = false)

        element_value = all_elements(type)
        
        case element_value.class.to_s
        when "Array"
          element_value.each do |value|
            add map_property(type.to_s), value, required
          end
        when "String"
          add map_property(type.to_s), element_value, required
        else
          raise "Type not supported"
        end        
        
      end

      # Gets the mapping from a xml element name to a property. This looks
      # up the property map; if no entry is found the default value (which
      # is the name of the element) will be used.
      def map_property(name)
        property = PROPERTY_MAP[name.to_s]
        property ||= name.underscore
        N::URI.make_uri(property, ':', N::HYPER)
      end

      # Get a source name
      def source_name
        return N::LOCAL + "bibliographical_card/" + Digest::SHA1.hexdigest(rand.to_s)
      end

    end
  end
end
