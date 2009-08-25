module TaliaCore
  module ActiveSourceParts
    module ClassMethods
      
      # Accessor for addtional rdf types that will automatically be added to each
      # object of that Source class
      def additional_rdf_types 
        @additional_rdf_types ||= []
      end

      # New method for ActiveSources. If a URL of an existing Source is given as the only parameter, 
      # that source will be returned. This makes the class work smoothly with our ActiveRDF version
      # query interface.
      #
      # Note that any semantic properties that were passed in to the constructor will be assigned
      # *after* the ActiveRecord "create" callbacks have been called.
      def new(*args)
        the_source = if((args.size == 1) && (args.first.is_a?(Hash)))
          # We have an option hash to init the source
          attributes = split_attribute_hash(args.first)
          the_source = super(attributes[:db_attributes])
          the_source.add_semantic_attributes(false, attributes[:semantic_attributes])
          the_source
        elsif(args.size == 1 && ( uri_s = uri_string_for(args[0]))) # One string argument should be the uri
          # Either the current object from the db, or a new one if it doesn't exist in the db
          find(:first, :conditions => { :uri => uri_s } ) || super(:uri => uri_s)
        else
          # In this case, it's a generic "new" call
          super
        end
        the_source.add_additional_rdf_types if(the_source.new_record?)
        the_source
      end

      # Retrieves a new source with the given type. This gets a propety hash
      # like #new, but it will correctly initialize a source of the type given
      # in the hash.
      def create_source(args)
        type = args.delete(:type) || args.delete('type')
        raise(ArgumentError, "Not type given") unless(type)
        klass = "TaliaCore::#{type}".constantize
        klass.new(args)
      end

      # Create sources from XML. The result is either a single source or an Array
      # of sources, depending on wether the XML contains multiple sources.
      #
      # The resulting source objects will be plain from #new, unsaved.
      def create_from_xml(xml)
        source_properties = ActiveSourceParts::Xml::SourceReader.sources_from(xml)
        sources = source_properties.collect { |props| ActiveSource.create_source(props) }
        (sources.size == 1) ? sources.first : sources
      end

      # This method is slightly expanded to allow passing uris and uri objects
      # as an "id"
      def exists?(value)
        if(uri_s = uri_string_for(value))
          super(:uri => uri_s)
        else
          super
        end
      end


      # Finder also accepts uris as "ids". There are also some additional options
      # that are accepted:
      # 
      # [*:find_through*] accepts and array with an predicate name and an object
      #                   value/uri, to search for predicates that match the given predicate/value 
      #                   combination
      # [*:type] specifically looks for sources with the given type.
      # [*:find_through_inv*] like :find_through, but for the "inverse" lookup
      # [*:prefetch_relations*] if set to "true", this will pre-load all semantic
      #                         relations for the sources (experimental, not fully implemented yet)
      def find(*args)
        prefetching = false
        if(args.last.is_a?(Hash))
          options = args.last
          prefetching =  options.delete(:prefetch_relations)
          if(options.empty?) # If empty we remove the args hash, so that the 1-param uri search works
            args.pop
          else
            prepare_options!(args.last)
          end
        end
        result = if(args.size == 1 && (uri_s = uri_string_for(args[0])))
          src = super(:first, :conditions => { :uri => uri_s })
          raise(ActiveRecord::RecordNotFound, "Not found: #{uri_s}") unless(src)
          src
        else
          super
        end

        prefetch_relations_for(result) if(prefetching)

        result
      end
      
      # Semantic version of ActiveRecord::Base#update - the id may be a record id or an URL,
      # and the attributes may contain semantic attributes. See the update_attributes method
      # for details on how the semantic attributes behave.
      def update(id, attributes)
        record = find(id)
        raise(ActiveRecord::RecordNotFound) unless(record)
        record.update_attributes(attributes)
      end
      
      # Like update, only that it will overwrite the given attributes instead
      # of adding to them
      def rewrite(id, attributes)
        record = find(id)
        raise(ActiveRecord::RecordNotFound) unless(record)
        record.rewrite_attributes(attributes)
      end

      # The pagination will also use the prepare_options! to have access to the
      # advanced finder options
      def paginate(*args)
        prepare_options!(args.last) if(args.last.is_a?(Hash))
        super
      end

      # If will return itself unless the value is a SemanticProperty, in which
      # case it will return the property's value.
      def value_for(thing)
        thing.is_a?(SemanticProperty) ? thing.value : thing
      end
      
      # Returns true if the given attribute is one that is stored in the database
      def db_attr?(attribute)
        db_attributes.include?(attribute.to_s)
      end
      
      # Tries to expand a generic URI value that is either given as a full URL
      # or a namespace:name value.
      #
      # This will assume a full URL if it finds a ":/" string inside the URI. 
      # Otherwise it will construct a namespace - name URI
      def expand_uri(uri) # TODO: Merge with uri_for ?
        assit_block do |errors| 
          unless(uri.respond_to?(:uri) || uri.kind_of?(String)) || uri.kind_of?(Symbol)
            errors << "Found strange object of type #{uri.class}"
          end
          true
        end
        uri = uri.respond_to?(:uri) ? uri.uri.to_s : uri.to_s
        return uri if(uri.include?(':/'))
        N::URI.make_uri(uri).to_s
      end
      
      # Splits the attribute hash that is given for new, update and the like. This
      # will return another hash, where result[:db_attributes] will contain the
      # hash of the database attributes while result[:semantic_attributes] will
      # contain the other attributes. 
      #
      # The semantic attributes will be expanded to full URIs whereever possible.
      #
      # This method will *not* check for attributes that correspond to singular
      # property names.
      def split_attribute_hash(attributes)
        assit_kind_of(Hash, attributes)
        db_attributes = {}
        semantic_attributes = {}
        attributes.each do |field, value|
          if(db_attr?(field))
            db_attributes[field] = value
          else
            semantic_attributes[expand_uri(field)] = value
          end
        end
        { :semantic_attributes => semantic_attributes, :db_attributes => db_attributes }
      end
      
      private
      
      # The attributes stored in the database
      def db_attributes
        @db_attributes ||= ActiveSource.new.attribute_names
      end
      
      # Helper to define a "additional type" in subclasses which will 
      # automatically be added on Object creation
      def has_rdf_type(*types)
        @additional_rdf_types ||= []
        types.each { |t| @additional_rdf_types << t.to_s }
      end

      # Helper to define a "singular accessor" for something (e.g. siglum, catalog)
      # This accessor will provide an "accessor" method that returns the
      # single property value directly and an assignment method that replaces
      # the property with the value.
      #
      # The Source will cache newly set singular properties internally, so that
      # the new value is immediately reflected on the object. However, the
      # change will only be made permanent on #save! - and saving will also clear
      # the cache
      def singular_property(prop_name, property)
        prop_name = prop_name.to_s
        @singular_props ||= []
        return if(@singular_props.include?(prop_name))
        raise(ArgumentError, "Cannot overwrite method #{prop_name}") if(self.instance_methods.include?(prop_name) || self.instance_methods.include?("#{prop_name}="))
        # define the accessor
        define_method(prop_name) do
          prop = self[property]
          assit_block { |err| (prop.size > 1) ? err << "Must have at most 1 value for singular property #{prop_name} on #{self.uri}. Values #{self[property]}" : true }
          prop.size > 0 ? prop[0] : nil
        end

        # define the writer
        define_method("#{prop_name}=") do |value|
          prop = self[property]
          prop.remove
          prop << value
        end

        # define the finder
        (class << self ; self; end).module_eval do
          define_method("find_by_#{prop_name}") do |value, *optional|
            raise(ArgumentError, "Too many options") if(optional.size > 1)
            options = optional.last || {}
            finder = options.merge( :find_through => [property, value] )
            find(:all, finder)
          end
        end

        @singular_props << prop_name
        true
      end

      # This gets the URI string from the given value. This will just return
      # the value if it's a string. It will return the result of value.uri, if
      # that method exists; otherwise it'll return nil
      def uri_string_for(value)
        result = if value.is_a? String
          # if this is a local name, prepend the local namespace
          (value =~ /:/) ? value : (N::LOCAL + value).uri
        elsif(value.respond_to?(:uri))
          value.uri
        else
          nil
        end
        result = result.to_s if result
        result
      end


      # Takes the "advanced" options that can be passed to the find method and
      # converts them into "standard" find options.
      def prepare_options!(options)
        check_for_find_through!(options)
        check_for_type_find!(options)
        check_for_find_through_inv!(options)
      end

      # Checks if the :find_through option is set. If so, this expects the
      # option to have 2 values: The first representing the URL of the predicate
      # and the second the URL or value that should be matched.
      #
      # An optional third parameter can be used to force an object search on the
      # semantic_properties table (instead of active_sources) - if not present
      # this will be auto-guessed from the "object value", checking if it appears
      # to be an URL or not.
      #
      #   ...find(:find_through => [N::RDF::something, 'value', true]
      def check_for_find_through!(options)
        if(f_through = options.delete(:find_through))
          assit_kind_of(Array, f_through)
          raise(ArgumentError, "Passed non-hash conditions with :find_through") if(options.has_key?(:conditions) && !options[:conditions].is_a?(Hash))
          raise(ArgumentError, "Cannot pass custom join conditions with :find_through") if(options.has_key?(:joins))
          predicate = f_through[0]
          obj_val = f_through[1]
          search_prop = (f_through.size > 2) ? f_through[2] : !(obj_val.to_s =~ /:/)
          options[:joins] = default_joins(!search_prop, search_prop)
          options[:conditions] ||= {}
          options[:conditions]['semantic_relations.predicate_uri'] = predicate.to_s
          if(search_prop)
            options[:conditions]['obj_props.value'] = obj_val.to_s
          else
            options[:conditions]['obj_sources.uri'] = obj_val.to_s
          end
        end
      end

      # Check for the :find_through_inv option. This expects the 2 basic values
      # in the same way as :find_through.
      #
      # find(:find_through_inv => [N::RDF::to_me, my_uri]
      def check_for_find_through_inv!(options)
        if(f_through = options.delete(:find_through_inv))
          assit_kind_of(Array, f_through)
          raise(ArgumentError, "Passed non-hash conditions with :find_through") if(options.has_key?(:conditions) && !options[:conditions].is_a?(Hash))
          raise(ArgumentError, "Cannot pass custom join conditions with :find_through") if(options.has_key?(:joins))
          options[:joins] = default_inv_joins
          options[:conditions] ||= {}
          options[:conditions]['semantic_relations.predicate_uri'] = f_through[0].to_s
          options[:conditions]['sub_sources.uri'] = f_through[1].to_s
        end
      end


      # Checks for the :type option in the find options. This is the same as
      # doing a :find_through on the rdf type
      def check_for_type_find!(options)
        if(f_type = options.delete(:type))
          options[:find_through] = [N::RDF::type, f_type.to_s, false]
          check_for_find_through!(options)
        end
      end
      
    end
  end
end