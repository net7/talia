require 'rexml/document'
require 'yaml'
require 'open-uri'
require 'cgi'

require 'talia_util/hyper_importer/importer/caching'
require 'talia_util/hyper_importer/importer/cloning'

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

      # Any additional options for the import
      attr_accessor :import_options

      # Creates a new importer, using the given element to initialize it. This
      # reads the information from the xml element into the object.
      def initialize(element_xml)
        check_namespaces!
        @element_xml = element_xml
        source_name = get_text(element_xml, "siglum")
        assit(source_name && source_name != "", "Source with no name!")
        if(source_name && source_name != "")
          @source = get_source_with_class(source_name, get_class_for(element_xml))
          sigla = @source.hyper::siglum
          sigla << source_name if(sigla.size == 0) # No use to fast-add if we need the size
        end
      end
      
      # Sets the credentials that are use for HTTP downloading files. If this
      # isn't set, it will just be ignored
      def set_credentials(login, password)password
        @credentials = { :http_basic_authentication => [login, password] }
      end
      
      # This will be called to initiate the import on this importer. this
      # will be called from self.import, and should not be called directly and
      # should not be overwritten.
      def do_import!
        benchmark('Import of ' + @source.uri.local_name) do
          benchmark('Import relations') { import_relations! }
          benchmark('Import types') { import_types! }
          benchmark('Top import') do
            add_property_from(@element_xml, 'title', (self.class.needs_title ? :required : nil)) # The title should always exist
            import! # Calls the import features of the subclass
          end
          @source.autosave_rdf = true # Reactivate rdf creation for final save
          benchmark("Saving source", Logger::DEBUG) do
            @source.save! # Save the source when the import is complete
          end
        end
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
      def self.import(element_xml, options = {})
        assit_real_string(element_xml.root.name, "XML root element must have a name")
        importer = importer_for_element(element_xml.root)
        importer.import_options = options if(options)
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
      
      # The Source class that should be used for Source created by this importer
      def self.configured_source_class
        @configured_source_class
      end
      
      # Select the source class to be used for this importer. This overrides
      # the automatic setting (which is: use the Source class which matches
      # the name of the element, and fall back to TaliaCore::Source)
      def self.source_class(klass)
        @configured_source_class = klass
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
      
      # Allows to add a hook that will be called if the given relation is imported.
      # This can be used to directly add more stuff (like sorting) to a related
      # object, so that it doesn't have to be re-retrieved later on.
      #
      # NOTE: The object source that it passed to the callback will *not* be
      # saved automatically.
      def self.on_import_relation(relation, target = nil, &block)
        @import_rel_callbacks ||= {}
        raise(ArgumentError, "Must give either block or symbol for the callback.") if(target && block)
        callback = target.to_sym if(target)
        callback = block if(block)
        raise(ArgumentError, "Must give block or symbol for the callback.") unless(callback)
        @import_rel_callbacks[relation] = callback
      end
      
      def self.import_callback_for(relation)
        @import_rel_callbacks[relation] if(@import_rel_callbacks)
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
      #
      # If a default value is given, it will be used as a default when the node
      # does not exist or is empty.
      #
      # The default value can be the special value :required - which means that
      # there is no default and
      def add_property_from(root, name, required = false, default_value = nil)
        if(node = root.elements[name])
          ## Create an URI for the new property
          property = N::URI.make_uri(map_property(name), ':', N::HYPER)
          text = default_value
          text = node.text.strip if(node.text && node.text.strip != '')
          quick_add_predicate(@source, property, text) if(text)
        else
          assit(!required, "The node #{name} is required to exist.")
        end
      end
      
      # This adds a property "explicitly", if the automatic mapping cannot be
      # used
      def add_property_explicit(root, name, property, required = false)
        if(node = root.elements[name])
          ## Create an URI for the new property
          quick_add_predicate(@source, property, node.text.strip) if(node.text && node.text.strip != "")
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
      
      # Gets the class of Source that the importer produces
      def get_class_for(element)
        config_class = self.class.configured_source_class
        return config_class if(config_class) # If a class was hard-coded
        
        # Try to select a class by type
        type_class = nil
        begin
          type = element.name.camelize
          type_class = TaliaCore.const_get(type)
        rescue NameError
          type_class = TaliaCore::Source # if nothing was found, use the Source class
        end
        
        type_class
      end
      
      # Gets or creates the Source with the given name. If the Source already
      # exists, it will add the given types to it
      def get_source(source_name, *types)
        
        src = get_source_with_class(source_name, nil)
        assit_kind_of(TaliaCore::Source, src)
        
        if(types.size > 0) # Bail out if there are no types
          type_list = src.types
          touched = false
          types.each do |type|
            unless(type_list.include?(type))
              type_list << type
              touched = true
            end
          end
          # Only save if there were types modified
          src.save! if(touched)
        end
        
        src
      end

      # Get the given source from a source name (see get_or_create_source),
      # this will create a source with the given name in the local namespace
      def get_source_with_class(source_name, klass, save_new = true)
        source_uri = irify(N::LOCAL + source_name)
        get_or_create_source(source_uri, klass, save_new)
      end
      
      # Sets the default catalog on the source, if applicable. This will
      # return true if the catalog is reset
      def set_catalog(src)
        result = false
        if(src.is_a?(TaliaCore::ExpressionCard))
          catalog = get_catalog() || TaliaCore::Catalog.default_catalog
          if(src.catalog != catalog)
            src.catalog = catalog
            result = true
          end
        end
        result
      end

      # Gets the URI for the given source, depending on the currently set
      # catalog
      def uri_on_catalog(source_uri)
        base_uri = if(get_catalog)
          get_catalog.uri.to_s + '/'
        else
          N::LOCAL
        end
        name = source_uri.local_name.to_s
        irify(base_uri + name)
      end

      # Gets a source with the given type (type must be a class). If the source
      # already exists, this will change the Sources class (type property).
      #
      # If klass is nil, it will default to the Source class but will not
      # attempt to change the type on existing sources.
      #
      # The sources from the method will *not* automatically create their RDF
      # on save!
      def get_or_create_source(source_uri, klass, save_new = true)
        set_class = (klass != nil) # this indicates if the class must be reset on an existing object

        klass ||= TaliaCore::Source
        # Set the URI on the given catalog (<= checks for subclass here)
        source_uri = uri_on_catalog(source_uri) if(klass <= TaliaCore::ExpressionCard)

        raise(ArgumentError, "This must have a klass as parameter: #{source_uri}") unless(klass.is_a?(Class))
        src = SourceCache.cache[source_uri]
        if(src)
          # If the Source already exists, push the types in
          src.autosave_rdf = false
          # If the class
          klass_name = klass.to_s.demodulize
          if((src[:type] != klass_name) && set_class)
            # In this case we will have to change the STI type on the Source
            # this happens if the Source had been created before the import
            # as a referenced object on another Source
            assit(src[:type] == 'Source', "Source should not change from #{src[:type]} to #{klass_name}: #{src.uri} ")
            src[:type] = klass_name
            src.save!
            src = klass.find(src.id)
            src.save! if(set_catalog(src))
            # Update the cache with the changed source!
            SourceCache.cache[source_uri] = src
            src.autosave_rdf = false
          end
        else
          src = klass.new(source_uri)
          src.primary_source = primary_source? if(src.is_a?(TaliaCore::Source))
          set_catalog(src)
          src.save! if(save_new)
          src.autosave_rdf = false
          # Add the new source to the cache
          SourceCache.cache[source_uri] = src
      end
      
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
              
              object_source = get_source(object)

              quick_add_predicate(@source, predicate_uri, object_source)
              
              if(callback = self.class.import_callback_for(predicate_uri))
                case callback
                when Symbol
                  self.send(callback, object_source)
                when Proc
                  callback.call(object_source)
                else
                  raise(ArgumentError, "Illegal callback.")
                end
              end
              
            else
              # Skip empty object for relation
            end
          rescue Exception => e
            assit_fail("Error '#{e}' during relation import (#{predicate}, #{object}), possibly malformed XML?\n Backtrace: #{e.backtrace.join("\n")}\n")
          end
        end
      end
      
      
      # Makes an URI of the given value and retrieves a type source, using the
      # type cache
      def cached_type_by_string(value)
        Importer.type_cache_retrieve(N::URI.make_uri(value, ':', N::HYPER))
      end

      # Add the types by using the type map and the type configured in the
      # importer.
      def import_types!
        if(self.class.get_source_type)
          quick_add_predicate(@source, N::RDF.type, cached_type_by_string(self.class.get_source_type))
        end
        
        hyper_type = get_text(@element_xml, 'type')
        hyper_subtype = get_text(@element_xml, 'subtype')
        
        if(hyper_subtype && TYPE_MAP[hyper_subtype])
          quick_add_predicate(@source, N::RDF.type, cached_type_by_string(TYPE_MAP[hyper_subtype]))
        elsif(hyper_type && TYPE_MAP[hyper_type])
          quick_add_predicate(@source, N::RDF.type, cached_type_by_string(TYPE_MAP[hyper_type]))
        else
          assit(!hyper_type, "There was no mapping for the type/subtype (#{hyper_type}/#{hyper_subtype})")
        end
        
        # Little kludge: We also "hardwire" original types to the object
        quick_add_predicate(@source, N::HYPER.subtype, hyper_subtype) if(hyper_subtype)
        quick_add_predicate(@source, N::HYPER.type, hyper_type) if(hyper_type)
      end
      
      # Imports the file that is included in the xml, and all releant properties
      def import_file!
        file_name = get_text(@element_xml, 'file_name')
        file_url = get_text(@element_xml, 'file_url')
        file_content_type = get_text(@element_xml, 'file_content_type')
        if(file_name && file_url && file_content_type)
          benchmark('Importing file ' + file_url) do
            begin
            
              # First, check the data type of the file - we'll use the file name
              # extension for that at the moment - not the file_content_type
              file_ext = File.extname(file_name).downcase
              mime_type = process_content_type(file_content_type, file_ext)
              data_records = if(%w(.xml .hnml .tei .html .htm .xhtml).include?(file_ext))
                load_from_data_url!(:XmlData, file_name, file_url)
              elsif(%w(.jpg .gif .jpeg .png .tif).include?(file_ext))
                load_image_from_url!(file_name, file_url)
              elsif(%w(.txt).include?(file_ext))
                load_from_data_url!(:SimpleText, file_name, file_url)
              elsif(%w(.pdf).include?(file_ext))
                load_from_data_url!(:PdfData, file_name, file_url)
              end
            
              # Check if we really got a data object, otherwise bail out
              unless(data_records && (data_records.size > 0))
                assit_fail("Got unknown file extension: #{file_ext}, aborting import")
                return
              end
            
              data_records.each { |data| @source.data_records << data }
              quick_add_predicate(@source, N::DCNS::format, mime_type)
            rescue Exception => e
              assit_fail("Exeption importing file #{file_name}: #{e}\n#{e.backtrace.join("\n")}\n")
            end
          end
        else
          assit(!file_name && !file_url && !file_content_type, "Incomplete file definition on Source #{@source.uri.local_name}")
        end
      end
      
      # Checks the given content_type and tries to make some kind of MIME type
      # of it. The extension will be used for "dubios" content types, that
      # have something like 'image' specified
      def process_content_type(content_type, extension)
        content_type = content_type.downcase
        content_type = extension[1..-1] if(content_type == 'image')
        case content_type
        when 'generic xml':
            'text/xml'
        when 'html', 'xml':
            "text/#{content_type}"
        when 'xhtml':
            'application/xhtml+xml'
        when 'hnml', 'tei', 'tei-p4', 'tei-p5', 'gml', 'wittei':
            "application/xml+#{content_type}"
        when 'jpg', 'jpeg':
            'image/jpeg'
        when 'gif':
            'image/gif'
        when 'tif', 'tiff':
            'image/tiff'
        when 'png':
            'image/png'
        when 'pdf':
            'application/pdf'
        else
          assit_fail("Unknown type #{content_type}")
        end
      end
      
      # Attempts to create an IipData object with pre-prepared images if possible
      # Returns true if (and only if) the object has been created with existing
      # data. Always fals if the data_record is not an IipData object or the
      # :prepared_images option is not set.
      def prepare_image_from_existing!(iip_record, image_record, url, location)
        return false unless(iip_record.is_a?(TaliaCore::DataTypes::IipData) && image_record.is_a?(TaliaCore::DataTypes::ImageData))
        return false unless(import_options && import_options[:prepared_images])
        
        file_ext = File.extname(url)
        file_base = File.basename(url, file_ext)

        thumb_file = File.join(import_options[:prepared_images], 'thumbs', "#{file_base}.gif")
        pyramid_file = File.join(import_options[:prepared_images], 'pyramids', "#{file_base}.tif")
        orig_file_pattern = File.join(import_options[:prepared_images], 'originals', "#{file_base}.*")
        # We need to fix the pattern, also the Dir[] doesn't like unescaped brackets
        orig_file_pattern.gsub!(/\[/, '\\[')
        orig_file_pattern.gsub!(/\]/, '\\]')
        orig_file_l = Dir[orig_file_pattern]
        raise(ArgumentError, 'Original find not found for ' + url) unless(orig_file_l.size > 0)
        orig_file = orig_file_l.first
        assit_block { %w(.jpg .jpeg .png).include?(File.extname(orig_file).downcase) }
        
        iip_record.create_from_existing(thumb_file, pyramid_file)
        image_record.create_from_file(location, orig_file)

        true
      end

      # Opens the "original" image for the given url. This will convert the
      # image to PNG image and the yield the io object for the PNG.
      def open_original_image_for(url)
        unconverted_file = url
        converted_file = File.join(Dir.tmpdir, "talia_convert_#{rand 10E16}")
        clean_unconverted = false # Indicates if the unconverted file must be deleted

        # Check if we need to download the unconverted file
        if(!File.exists?(url))
          # First load this from the web to a temp file
          tempfile = File.join(Dir.tmpdir, "talia_down_#{rand 10E16}#{File.extname(url)}")
          open_from_url(url) do |io|
            File.open(tempfile) do |fio|
              fio << io.read # Download the file
            end
            url = unconverted_file
            clean_unconverted = true
          end
        end

        TaliaCore::ImageConversions.to_png(unconverted_file, converted_file)
        File.open(converted_file) do |io|
          yield(io)
        end

        FileUtils.rm(converted_file)
        FileUtils.rm(unconverted_file) if(clean_unconverted)
      end

      # Loads an image for the given URL. This is a tad more complex than loading
      # the data into a data record: It will create both an IIP data object and
      # an Image data object. The image data record will contain the original
      # image file. If the original image is not a JPEG or PNG file, it will be
      # converted to PNG. (This is to always have an original image that can
      # be converted to PDF).
      def load_image_from_url!(location, url)
        iip_record = TaliaCore::DataTypes::IipData.new
        image_record = TaliaCore::DataTypes::ImageData.new
        records = [iip_record, image_record]
        return records if(prepare_image_from_existing!(iip_record, image_record, url, location))

        is_file = File.exists?(url)
        ext = File.extname(url).downcase
        if(%w(.jpeg .jpg .png).include?(ext)) # The image doesn't need conversion
          if(is_file)
            iip_record.create_from_file(location, url)
            image_record.create_from_file(location, url)
          else
            open_from_url(url) do |io|
              data = io.read # Cache the data to use it with both records
              iip_record.create_from_data(location, data)
              iip_record.create_from_data(location, data)
            end
          end
        else
          # We have an image that needs to be converted
          open_original_image_for(url) do |io|
            data = io.read # Cache the data to use it with both records
            iip_record.create_from_data(location, data)
            iip_record.create_from_data(location, data)
          end
        end

        return records
      end

      # Opens the given (web) URL, using URL encoding and necessary substitutions.
      # The user must pass a block which will receive the io object from
      # the url
      def open_from_url(url)
        url = URI.encode(url)
        url.gsub!(/\[/, '%5B') # URI class doesn't like unescaped brackets
        url.gsub!(/\]/, '%5D')
        open_args = [ url ]
        open_args << @credentials if(@credentials)

        begin
          open(*open_args) do |io|
            yield(io)
          end
        rescue Exception => e
          raise(IOError, "Error loading #{url} for #{@source.uri} (when file: #{url}, open_args: [#{open_args.join(', ')}]) #{e}")
        end
      end

      # Loads a data file from the given URL. This passes creates the given
      # record from the data at the given URL, using the given location string
      # on the data record.
      def load_from_data_url!(record_type, location, url)
        data_record = TaliaCore::DataTypes.const_get(record_type).new
        
        # Let's first try if the url is a real file. In this case, we can
        # save ourselves a lot of heavy lifting.
        if(File.exist?(url))
          data_record.create_from_file(location, url)
        else
          open_from_url(url) do |io|
            data_record.create_from_data(location, io) 
          end
        end
        
        [ data_record ]
      end
      
      # Adds a relation to another source from the Source that is imported.
      # If the related Source does not yet exist it will be created. This
      # means that a relation <tt>origin -[relation]-> destination</tt> is
      # created.
      #
      # All parameters should be URI objects or URI strings.
      #
      # The origin is optional. If it isn't given, the origin (subject) of
      # the relation will be the currently imported Source.
      def add_source_rel(relation, destination, origin = nil)
        origin ||= @source
        object_source = get_source(destination)
        quick_add_predicate(origin, relation, object_source)
        # Make sure that 'external' sources are saved with RDF data. For
        # the member source this will automatically be called on import
        origin.autosave_rdf = true if(origin != @source)
      end

      # This is a fast-add-hack for a predicate. It basically bypasses the
      # whole getting of a predicate list and simply forces the values to
      # the database. This should avoid any database hits except the one
      # that actually adds the elements.
      def quick_add_predicate(source, predicate, value)
        source[predicate] << value
        end

      # Checks for the namespaces which must be defined for the
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
      
      # Gain access to the logger
      def logger
        TaliaCore::Initializer.talia_logger
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
      
      # Benchmarking helper
      def benchmark(message, level = Logger::INFO, &block)
        unless(logger.level <= level)
          block.call
        else
          elapsed = Benchmark.realtime(&block)
          logger.add(level, "\033[1m\033[4m\033[35m#{self.class.name}\033[0m [Importing #{Time.now.to_s(:long)}] #{message} completed in %.2f secs" % elapsed)
        end
      end
      
    end
  end
end