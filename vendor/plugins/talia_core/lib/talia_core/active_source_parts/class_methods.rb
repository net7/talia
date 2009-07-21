module TaliaCore
  module ActiveSourceParts
    module ClassMethods
      
      # Accessor for addtional rdf types that will automatically be added to each
      # object of that Source class
      def additional_rdf_types 
        @additional_rdf_types ||= []
      end

      # This helps the "new" method to either return an existing element or
      # instead create a new object with the given uri.
      # 
      # We know that this is a hack. TODO: No real reason for this, should probably
      # be removed.
      def new(*args)
        the_source = nil
        if(args.size == 1 && ( uri_s = uri_string_for(args[0]))) # One string argument should be the uri
          # if we don't find the something, let's create a new source
          unless(the_source = find(:first, :conditions => { :uri => uri_s } ))
            the_source = super() # brackets avoid passing any parameters
            the_source.uri = uri_s
          end
        else
          # In this case, it's a generic "new" call
          the_source = super
        end
        the_source.types << the_source.class.additional_rdf_types if(the_source.new_record?)
        the_source
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
      
      private
      
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