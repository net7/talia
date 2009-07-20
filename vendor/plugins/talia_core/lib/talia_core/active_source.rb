require 'active_source/rdf'
require 'active_source/predicate_handler'

module TaliaCore
  
  # This class encapsulate the basic "Source" behaviour for an element in the
  # semantic store. This is the baseclass for all things that are represented
  # as an "Resource" (with URL) in the semantic store.
  #
  # If an object is modified but <b>not</b> saved, the ActiveSource does <b>not</b>
  # guarantee that the RDF will always be in sync with the database. However,
  # a subsequent saving of the object will re-sync the RDF.
  #
  # An effort is made to treat RDF and database writes in the same way, so that
  # they should <i>usually</i> be in sync:
  #
  # * Write operations are usually lazy, the data should only be saved once
  #   save! is called. However, ActiveRecord may still decide that the objects
  #   need to be saved if they are involved in other operations.
  # * Operations that clear a predicate are <b>immediate</b>. That also means
  #   that using singular property setter, if
  #   used will immediately erase the old value. If the record is not saved,
  #   the property will be left empty (and not revert to the original value!)
  class ActiveSource < ActiveRecord::Base
    
    # Relations where this source is the subject of the triple
    has_many_polymorphs :objects, :from => [:active_sources, :semantic_properties],
      :as => :subject, :through => :semantic_relations, :namespace => :talia_core,
      :skip_duplicates => false
    has_many :semantic_relations, :foreign_key => 'subject_id', :class_name => 'TaliaCore::SemanticRelation', :dependent => :destroy
           
    # Relations where this source is the object of the relation
    has_many :related_subjects,
      :foreign_key => 'object_id',
      :class_name => 'TaliaCore::SemanticRelation'
    has_many :subjects, :through => :related_subjects
    
    validates_format_of :uri, :with => /\A\S*:.*\Z/
    validates_uniqueness_of :uri

    before_destroy :remove_inverse_properties # Remove inverse properties when destroying an element

    # We may wish to use the following Regexp.
    # It matches:
    #   http://discovery-project.eu
    #   http://www.discovery-project.eu
    #   http://trac.talia.discovery-project.eu
    #   http://trac.talia.discovery-project.eu/source
    #   http://trac.talia.discovery-project.eu/namespace#predicate
    #
    # validates_format_of :uri,
    #   :with => /^(http|https):\/\/[a-z0-9\_\-\.]*[a-z0-9_-]{1,}\.[a-z]{2,4}[\/\w\d\_\-\.\?\&\#]*$/i
    
    validate :check_uri
    
    # Accessor for addtional rdf types that will automatically be added to each
    # object of that Source class
    def self.additional_rdf_types 
      @additional_rdf_types ||= []
    end
    
    # This helps the "new" method to either return an existing element or
    # instead create a new object with the given uri.
    # 
    # We know that this is a hack. TODO: No real reason for this, should probably
    # be removed.
    def self.new(*args)
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
    def self.exists?(value)
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
    def self.find(*args)
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
    def self.paginate(*args)
      prepare_options!(args.last) if(args.last.is_a?(Hash))
      super
    end

    # If will return itself unless the value is a SemanticProperty, in which
    # case it will return the property's value.
    def self.value_for(thing)
      thing.is_a?(SemanticProperty) ? thing.value : thing
    end

    # Helper
    def value_for(thing)
      self.class.value_for(thing)
    end

    # To string: Just return the URI. Use to_xml if you need something more
    # involved.
    def to_s
      self[:uri]
    end

    # Works in the normal way for database attributes. If the value
    # is not an attribute, it tries to find objects related to this source
    # with the value as a predicate URL and returns a collection of those.
    #
    # The assignment operator remains as it is for the ActiveRecord.
    def [](attribute)
      if(attribute_names.include?(attribute.to_s))
        super(attribute)
      else
        get_objects_on(attribute)
      end
    end
    alias :get_attribute :[]

    # Assignment to an attribute. This will overwrite all current triples.
    def []=(attribute, value)
      if(attribute_names.include?(attribute.to_s))
        super(attribute, value)
      else
        pred = get_attribute(attribute)
        pred.remove
        pred << value
      end
    end

    # Returns a special object which collects the "inverse" properties 
    # of the Source - these are all RDF properties which have the current
    # Source as the object.
    #
    # The returned object supports the [] operator, which allows to fetch the
    # "inverse" (the RDF subjects) for the given predicate.
    #
    # Example: <tt>person.inverse[N::FOO::creator]</tt> would return a list of
    # all the elements of which the current person is the creator.
    def inverse
      inverseobj = Object.new
      inverseobj.instance_variable_set(:@assoc_source, self)
      
      class << inverseobj     
        
        def [](property)
          @assoc_source.subjects.find(:all, :conditions => { 'semantic_relations.predicate_uri' => property.to_s } )
        end
        
        private :type
      end
      
      inverseobj
    end
    
    # Accessor that allows to lookup a namespace/name combination. This works like
    # the [] method: I will return an array-like object on predicates can be
    # manipulated.
    def predicate(namespace, name)
      get_objects_on(get_namespace(namespace, name))
    end
    
    # Setter method for predicates by namespace/name combination. This will 
    # *add a precdicate triple, not replace one!*
    def predicate_set(namespace, name, value)
      predicate(namespace, name) << value
    end
    
    # Setter method that will only add the value if it doesn't exist already
    def predicate_set_uniq(namespace, name, value)
      pred = predicate(namespace, name)
      pred << value unless(pred.include?(value))
    end
    
    # Replaces the given predicate with the value. Good for one-value predicates
    def predicate_replace(namespace, name, value)
      pred = predicate(namespace, name)
      pred.remove
      pred << value
    end
    
    # Gets the direct predicates (using the database)
    def direct_predicates
      rels = SemanticRelation.find_by_sql("SELECT DISTINCT predicate_uri FROM semantic_relations WHERE subject_id = #{self.id}")
      rels.collect { |rel| N::Predicate.new(rel.predicate_uri) }
    end
    
    # Gets the inverse predicates
    def inverse_predicates
      rels = SemanticRelation.find_by_sql("SELECT DISTINCT predicate_uri FROM semantic_relations WHERE object_id = #{self.id}")
      rels.collect { |rel| N::Predicate.new(rel.predicate_uri) }
    end

    # Returns if the Facsimile is of the given type
    def has_type?(type)
      (self.types.include?(type))
    end

    # Writes the predicate directly to the database and the rdf store. The
    # Source does not need to be saved and no data is loaded from the database.
    # This is faster than adding the data normally and doing a full save,
    # at least if only one or two predicates are written.
    def write_predicate_direct(predicate, value)
      autosave = self.autosave_rdf?
      value.save! if(value.is_a?(ActiveSource) && value.new_record?)
      self.autosave_rdf = false
      self[predicate] << value
      uri_res = N::URI.new(predicate)
      # Now add the RDF data by hand
      if(value.kind_of?(Array))
        value.each do |v|
          my_rdf.direct_write_predicate(uri_res, v)
        end
      else
        my_rdf.direct_write_predicate(uri_res, value)
      end
      save! # Save without RDF save
      self.autosave_rdf = autosave
    end

    private

    # Get the namespace URI object for the given namespace
    def get_namespace(namespace, name = '')
      namesp_uri = N::Namespace[namespace]
      raise(ArgumentError, "Illegal namespace given #{namespace}") unless(namesp_uri)
      namesp_uri + name.to_s
    end


    # Takes over the validation for ActiveSources
    def validate
      self.class
    end

    # Check the uri should be different than N::LOCAL, this could happen when an user
    # leaves the input text blank.
    def check_uri
      self.errors.add(:uri, "Cannot be blank") if self.uri == N::LOCAL.to_s
    end
    
    # Helper to define a "additional type" in subclasses which will 
    # automatically be added on Object creation
    def self.has_rdf_type(*types)
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
    def self.singular_property(prop_name, property)
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
    def self.uri_string_for(value)
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
    
    # Returns the "default" join (meaning that it joins all the "triple tables"
    # together. The flags signal whether the relations and properties should 
    # be joined.
    def self.default_joins(include_rels = true, include_props = true)
      join = "LEFT JOIN semantic_relations ON semantic_relations.subject_id = active_sources.id "
      join << sources_join if(include_rels)
      join << props_join  if(include_props)
      join
    end

    # Joins sources on semantic relations
    def self.sources_join
      " LEFT JOIN active_sources AS obj_sources ON semantic_relations.object_id = obj_sources.id AND semantic_relations.object_type = 'TaliaCore::ActiveSource'"
    end

    # Joins properties on semantic relations
    def self.props_join
      " LEFT JOIN semantic_properties AS obj_props ON semantic_relations.object_id = obj_props.id AND semantic_relations.object_type = 'TaliaCore::SemanticProperty'"
    end

    # Returns the "default" join for reverse lookups
    def self.default_inv_joins
      join = "LEFT JOIN semantic_relations ON semantic_relations.object_id = active_sources.id AND semantic_relations.object_type = 'TaliaCore::ActiveSource' "
      join << " LEFT JOIN active_sources AS sub_sources ON semantic_relations.subject_id = sub_sources.id"
      join
    end

    
    # Takes the "advanced" options that can be passed to the find method and
    # converts them into "standard" find options.
    def self.prepare_options!(options)
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
    def self.check_for_find_through!(options)
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
    def self.check_for_find_through_inv!(options)
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
    def self.check_for_type_find!(options)
      if(f_type = options.delete(:type))
        options[:find_through] = [N::RDF::type, f_type.to_s, false]
        check_for_find_through!(options)
      end
    end

    # Remove the inverse properties, to be called before destroy. Doing this
    # through the polymorphic relation automatically could be a bit fishy...
    def remove_inverse_properties
      SemanticRelation.delete_all(["object_type = 'TaliaCore::ActiveSource' AND object_id = ?", self.id])
    end
    
  end
  
end
