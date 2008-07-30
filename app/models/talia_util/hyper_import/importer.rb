require 'rexml/document'
require 'yaml'
require 'open-uri'

module TaliaUtil
  
  module HyperImporter
    
    # Load the property mapping from file
    PROPERTY_MAP = YAML::load(File.open(File.expand_path(File.join(File.dirname(__FILE__), 'property_map.yml'))))
    # Load the type mapping from file
    TYPE_MAP = YAML::load(File.open(File.expand_path(File.join(File.dirname(__FILE__), 'type_map.yml'))))
    
    
    # Superclass for import modules of Hyper data imports. There is no explicit
    # error handling, just assertions: The import should make a best effort,
    # while the assertions can be used to report error conditions, if needed.
    class Importer
      
      # Creates a new importer, using the given element to initialize it. This
      # reads the information from the xml element into the object.
      def initialize(element_xml)
        check_namespaces!
        @element_xml = element_xml
        source_name = get_text(element_xml, "siglum")
        assit(source_name && source_name != "", "Source with no name!")
        if(source_name && source_name != "")
          @source = get_source(source_name)
        end
      end
      
      # Sets the credentials that are use for HTTP downloading files. If this
      # isn't set, it will just be ignored
      def set_credentials(login, password)
        @credentials = { :http_basic_authentication => [login, password] }
      end
      
      # This will be called to initiate the import on this importer. this
      # will be called from self.import, and should not be called directly and
      # should not be overwritten.
      def do_import!
        import_relations!
        import_types!
        add_property_from(@element_xml, 'title', self.class.needs_title) # The title should always exist
        import! # Calls the import features of the subclass
        @source.save! # Save the source when the import is complete
      end
      
      # Imports the data. To be overwritten by child classes
      def import!
        assit_fail("Should never call base class version of import.")
      end
      
      # Get the source that was imported by this importer.
      def source
        @source
      end
      
      # This is called to do the actual import. It will take the XML Element
      # of the element to be imported and return a new Source object
      def self.import(element_xml)
        assit_real_string(element_xml.root.name, "XML root element must have a name")
        importer = importer_for_element(element_xml.root)
        importer.do_import!
        importer.source
      end
      
      protected
      
      # Gets the importer for a given element name
      def self.importer_for_element(element)
        begin
          klass = TaliaUtil::HyperImporter.const_get("#{element.name.camelize}Importer")
          assit_kind_of(Class, klass, "Could not create a class from #{element.name}")
          klass.new(element)
        rescue RuntimeError => e
          assit_fail("Exception during import: #{e}")
        end
      end
      
      # Can be used by a subclass to assign a source type for that subclass.
      # E.g. <tt>source_type "hyper:paragraph"
      def self.source_type(type)
        # Check if we are not on the base class - this would create a global var
        assit(self.class != Importer, "Should never be called on the base class")
        @my_source_type = type
        assit_not_nil(@my_source_type)
      end
      
      # Get the source type
      def self.get_source_type
        @my_source_type
      end
      
      # This can be used to not require a title on the element (the
      # corresponding accessor, needs_title, will default to true
      def self.title_required(required)
        @title_required = required
      end
      
      def self.needs_title
        @title_required = true unless(defined?(@title_required))
      end
      
      # Gets the content of an element as a string. This looks for the direct
      # child of the root element with the given name, and returns the text
      # contained in that element - if any.
      def get_text(root, name)
        if(node = root.elements[name])
          node.text.strip if(node.text)
        end
      end
      
      # Creates a new attribute on the source, based on the mapping from the
      # given node. The attribute is assigned a value based on the contend
      # of the node.
      #
      # The node is acquired in the same way as in get_text.
      def add_property_from(root, name, required = false)
        if(node = root.elements[name])
          ## Create an URI for the new property
          property = N::URI.make_uri(map_property(name), ':', N::HYPER)
          @source[property] << node.text.strip if(node.text && node.text.strip != "")
        else
          assit(!required, "The node #{name} is required to exist.")
        end
      end
      
      # This adds a property "explicitly", if the automatic mapping cannot be
      # used
      def add_property_explicit(root, name, property, required = false)
        if(node = root.elements[name])
          ## Create an URI for the new property
          @source[property] << node.text.strip if(node.text && node.text.strip != "")
        else
          assit(!required, "The node #{name} is required to exist.")
        end
      end
      
      # Works like add_property from, but will create a relation to the a 
      # Source instead of value
      def add_rel_from(root, name, required = false)
        if(node = root.elements[name])
          ## Create an URI for the new property
          property = N::URI.make_uri(map_property(name), ':', N::HYPER)
          add_source_rel(property, node.text.strip) if(node.text && node.text.strip != "")
        else
          assit(!required, "The node n#{name} is required to exist.")
        end
      end
      
      # Gets the mapping from a xml element name to a property. This looks
      # up the property map; if no entry is found the default value (which 
      # is the name of the element) will be used.
      def map_property(name)
        property = PROPERTY_MAP[name]
        property ||= name.underscore
      end
      
      # Gets or creates the Source with the given name. If the Source already
      # exists, it will add the given types to it
      def get_source(source_name, *types)
        source_uri = irify(N::LOCAL + source_name)
        src = nil
        if(TaliaCore::Source.exists?(source_uri))
          # If the Source already exists, push the types in
          src = TaliaCore::Source.find(source_uri)
          type_list = src.types
          types.each do |type|
            type_list << type unless(type_list.include?(type))
          end
        else
          src = TaliaCore::Source.new(source_uri)
          src.types << types
          src.primary_source = primary_source?
          src.save!
        end
        
        assit_kind_of(TaliaCore::Source, src)
        src
      end
      
      # Reads all the relations on a Source that are given in the "relations"
      # element.
      def import_relations!
        @element_xml.root.elements.each("relations/relation") do |rel|
          # Add each relation with predicate and object
          begin
            if((object = get_text(rel, 'object')) && object != '')
              predicate = map_property(get_text(rel, 'predicate'))
              assit_real_string(predicate, "Predicate missing. Object: #{object}")
              assit_real_string(object, "Object missing. Predicate: #{predicate}")
              # Now we need to create/get the source for the relation,
              # and assign it to the current source
              predicate_uri = N::URI.make_uri(predicate, ':', N::HYPER)
              add_source_rel(predicate_uri, object)
            else
              # Skip empty object for relation
            end
          rescue Exception => e
            assit_fail("Error '#{e}' during relation import (#{predicate}, #{object}), possibly malformed XML?\n Backtrace: #{e.backtrace.join("\n")}\n")
          end
        end
      end
      
      # Add the types by using the type map and the type configured in the 
      # importer. 
      def import_types!
        if(self.class.get_source_type)
          @source.types << N::URI.make_uri(self.class.get_source_type, ':', N::HYPER)
        end
        
        hyper_type = get_text(@element_xml, 'type')
        hyper_subtype = get_text(@element_xml, 'subtype')
        
        if(hyper_subtype && TYPE_MAP[hyper_subtype])
          @source.types << N::URI.make_uri(TYPE_MAP[hyper_subtype], ':', N::HYPER)
        elsif(hyper_type && TYPE_MAP[hyper_type])
          @source.types << N::URI.make_uri(TYPE_MAP[hyper_type], ':', N::HYPER)
        else
          assit(!hyper_type, "There was no mapping for the type/subtype (#{hyper_type}/#{hyper_subtype})")
        end
        
        # Little kludge: We also "hardwire" original types to the object
        @source.hyper::subtype << hyper_subtype if(hyper_subtype)
        @source.hyper::type << hyper_type if(hyper_type)
      end
      
      # Imports the file that is included in the xml, and all releant properties
      def import_file!
        file_name = get_text(@element_xml, 'file_name')
        file_url = get_text(@element_xml, 'file_url')
        file_content_type = get_text(@element_xml, 'file_content_type')
        if(file_name && file_url && file_content_type)
          begin
            # First, check the data type of the file - we'll use the file name
            # extension for that at the moment - not the file_content_type
            file_ext = File.extname(file_name).downcase
            data_obj = if(%w(.xml .hnml .tei .html .htm).include?(file_ext))
              TaliaCore::DataTypes::XmlData.new
            elsif(%w(.jpg .gif .jpeg .png .tif).include?(file_ext))
              TaliaCore::DataTypes::ImageData.new
            elsif(%w(txt).include?(file_ext))
              TaliaCore::DataTypes::SimpleText.new
            end
            
            # Check if we really got a data object, otherwise bail out
            unless(data_obj)
              assit_fail("Got unknown file extension: #{file_ext}, aborting import")
              return
            end
            
            # Now that we have the data object, we try to fill it with the data
            # from the URL
            load_from_data_url!(data_obj, file_name, file_url)
            @source.data_records << data_obj
            @source.hyper::file_content_type << file_content_type
          rescue Exception => e
            assit_fail("Exeption importing file #{file_name}: #{e}\n#{e.backtrace.join("\n")}\n")
          end
        else
          assit(!file_name && !file_url && !file_content_type, "Incomplete file definition on Source #{@source.uri.local_name}")
        end
      end
      
      # Loads a data file from the given URL. This passes creates the given
      # record from the data at the given URL, using the given location string
      # on the data record.
      def load_from_data_url!(data_record, location, url)
        result = nil
        open_args = [ url ]
        open_args << @credentials if(@credentials)
        
        begin
          open(*open_args) do |io|
            result = data_record.create_from_data(location, io) 
          end
        rescue Exception => e
          raise(IOError, "Error loading #{url} (when file: #{File.expand_path(url)}: #{e}")
        end
        
        result
      end
      
      # Adds a relation to another source to the Source that is imported.
      # If the related Source does not yet exist it will be created.
      #
      # The destination parameter is a string or URI for the target Source;
      # the same goes for the predicate parameter.
      #
      # The origin is optional, if it is given, the property will be added to
      # the origin. Otherwise, the currently imported element will be used as
      # the origin.
      def add_source_rel(relation, destination, origin = nil)
        origin ||= @source
        object_source = get_source(destination)
        origin[relation] << object_source
      end
      
      # Checks for the hy_nietzsche namespace, which must be defined for the
      # import to work
      def check_namespaces!
        check_namespace!(:HYPER)
        check_namespace!(:DCNS)
      end
      
      # Checks a single namespace. Helper for check_namspaces.
      def check_namespace!(namespace)
        namespace = namespace.to_s.upcase
        unless(N.const_defined?(namespace))
          raise(RuntimeError, "ATTENTION: Namespace #{namespace} must be defined for the import to work.")
        end   
      end
      
      # Helper to indicate that the importer is for a primary source type. 
      # This can be used in the importer subclass to "tag" the importer
      # as a primary source importer.
      #
      # You can use this in the importer class like <tt>primary_source true</tt>
      def primary_source(value = true)
        # Assert that this is not called on the supertype. Due to the
        # handling of class variables in ruby this would break the mechanism.
        assit(self.class != Importer, "Must never call this method on superclass.")
        @@primary_source = value
      end
      
      # Checks if this is a primary source
      def primary_source?
        if(defined?(@@primary_source))
          @@primary_source
        else
          false
        end
      end
      
      # Removes all characters that are illegal in IRIs, so that the 
      # URIs can be imported
      def irify(uri)
        N::URI.new(uri.to_s.gsub( /[{}|\\^`\s]/, '+'))
      end
      
      # Stole from Rails
      def underscore(camel_cased_word)
        camel_cased_word.to_s.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end
      
    end
    
  end
end

# Require all the importer class files from this directory
# This automatically loads all files with importer classes
$: << File.expand_path(File.dirname(__FILE__))

# Require the superclasses first, cause the other depend on them
# Require importer superclasses
require File.join('contribution_importer')

# Now require all the importes (requires the superclasses again, but no worries
# that's what require is for ;-)
Dir.entries(File.expand_path(File.dirname(__FILE__))).each do |file|
  if(file =~ /_importer\.rb$/)
    require file
  end
end