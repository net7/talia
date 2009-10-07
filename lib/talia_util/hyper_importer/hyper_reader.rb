module TaliaUtil
  module HyperImporter
    module HyperReader

      # Load the property mapping from file
      PROPERTY_MAP = YAML::load(File.open(File.expand_path(File.join(File.dirname(__FILE__), 'property_map.yml'))))
      # Load the type mapping from file
      TYPE_MAP = YAML::load(File.open(File.expand_path(File.join(File.dirname(__FILE__), 'type_map.yml'))))

      def add_defaults(needs_title = true)
        default_properties(needs_title)
        add_catalog
      end
    
      # Set the current source as a primary sources
      def primary_source
        add N::TALIA.primary_source, 'true'
      end

      def default_properties(needs_title = true)
        add N::HYPER.siglum, from_element(:siglum), true
        add :uri, source_name(from_element(:siglum)), true
        add N::DCNS.title, from_element(:title), needs_title
        add_hyper_types
        nested :relations do
          nested :relation do
            predicate_uri = map_property(from_element(:predicate))
            assit(predicate_uri)
            object_uri = source_name(from_element(:object))
            add_rel predicate_uri, object_uri
          end
        end
      end

      # Default properties for contributions
      def add_contribution_defaults(needs_title = true)
        default_properties(needs_title)
        publishing_date = from_element(:publishing_date) 
        publishing_date = publishing_date.blank? ? current_timestamp : publishing_date
        add map_property('publishing_date'), publishing_date
        add_mapped :publisher
        add_mapped :language
        add_mapped :alreadyPublished
        add_mapped :curator_notes
        add_hyper_file
        nested :authors do
          nested :author do
            author_sig = @current.element.inner_html.strip
            add_rel N::DCNS.creator, author_sig unless(author_sig.blank?)
          end
        end
      end
      
      # Get a string containing the current date in UTC ISO8601 format as
      # expected by Talia
      def current_timestamp
        Time.now.getutc.strftime('%d-%m-%YT%H:%MZ')
      end

      # add a "Mapped property"
      def add_mapped(type, required = false)
        add map_property(type.to_s), from_element(type), required
      end
      
      def add_mapped_rel(type, required = false)
        add_rel map_property(type.to_s), from_element(type), required
      end
      
      # Add the default class and RDF type for the given type
      def add_default_type(type)
        add :type, type
        add N::RDF.type, (N::HYPER + type)
      end

      # Add the hyper types from the XML
      def add_hyper_types
        hyper_type = from_element(:type)
        hyper_subtype = from_element(:subtype)
        
        if(hyper_subtype && TYPE_MAP[hyper_subtype])
          add N::RDF.type, type_by_string(TYPE_MAP[hyper_subtype])
        elsif(hyper_type && TYPE_MAP[hyper_type])
          add N::RDF.type, type_by_string(TYPE_MAP[hyper_type])
        else
          assit(!hyper_type, "There was no mapping for the type/subtype (#{hyper_type}/#{hyper_subtype})")
        end
        
        # Little kludge: We also "hardwire" original types to the object
        add N::HYPER.subtype, hyper_subtype if(hyper_subtype)
        add N::HYPER.type, hyper_type if(hyper_type)
      end
      
      def type_by_string(value)
        N::URI.make_uri(value, ':', N::HYPER)
      end
      
      # Add a file specified in the old hyper xml properties
      def add_hyper_file
        url = from_element('file_url')
        return unless(url) # No file found
        options = {}
        location = from_element('file_name')
        options[:location] = location if(location)
        # Try to get the content type from the data
        content_type = from_element('file_content_type')
        content_type.downcase! if(content_type)
        mime_type = case content_type
        when 'image', nil
          ext = location ? File.extname(location)[1..-1] : File.extname(url)[1..-1]
          Mime::Type.lookup_by_extension(ext)
        when 'generic xml'
          Mime::Type.lookup('text/xml')
        else
          Mime::Type.lookup_by_extension(content_type)
        end
        options[:mime_type] = mime_type
        add_file url, options
        add N::DCNS.format, mime_type.to_s
      end

      # Gets the class of Source that the importer produces
      def add_default_class
        # Try to select a class by type
        type = nil
        begin
          type = @current.element.name.camelize
          type_class = TaliaCore.const_get(type)
        rescue NameError
          type = 'Source' # if nothing was found, use the Source class
        end

        add :type, type
      end

      # Sets the default catalog on the source, if applicable. 
      def add_catalog
        result = false
        if(current_is_a?(TaliaCore::ExpressionCard))
          if(catalog_name = from_element(:catalog))
            catalog_name = source_name(catalog_name)
            # Add a new source for the catalog
            add_source do
              add :uri, catalog_name
              add :type, 'Catalog'
            end unless(source_exists?(catalog_name))
          else
            # Do not reset an existing catalog if one exists
            return false if(@current.attributes['catalog'])
            catalog_name = TaliaCore::Catalog.default_catalog
          end

          add_rel N::HYPER.in_catalog, catalog_name

          true
        else
          false
        end
      end

      # Get a source name
      def source_name(name)
        name.blank? ? name : N::LOCAL + name
      end

      def from_current_name
        source_name(@current.element.name)
      end

      # Gets the mapping from a xml element name to a property. This looks
      # up the property map; if no entry is found the default value (which 
      # is the name of the element) will be used.
      def map_property(name)
        property = PROPERTY_MAP[name.to_s]
        property ||= name.underscore
        N::URI.make_uri(property, ':', N::HYPER)
      end

    end # End modules etc.
  end
end