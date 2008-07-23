require 'active_source/rdf'

module TaliaCore
  
  # This class encapsulate the basic "Source" behaviour for an element in the
  # semantic store. This is the baseclass for all things that are represented
  # as an "Resource" (with URL) in the semantic store.
  class ActiveSource < ActiveRecord::Base
    
    # Relations where this source is the subject of the triple
    has_many_polymorphs :objects, :from => [:active_sources, :semantic_properties],
      :as => :subject, :through => :semantic_relations, :namespace => :talia_core,
      :skip_duplicates => false
    has_many :semantic_relations, :foreign_key => 'subject_id', :class_name => 'TaliaCore::SemanticRelation'
           
    # Relations where this source is the object of the relation
    has_many :related_subjects,
      :foreign_key => 'object_id',
      :class_name => 'TaliaCore::SemanticRelation'
    has_many :subjects, :through => :related_subjects
    
    validates_format_of :uri, :with => /\A\S*:.*\Z/
    validates_uniqueness_of :uri
    
    # Accessor for addtional rdf types that will automatically be added to each
    # object of that Source class
    def self.additional_rdf_types 
      @additional_rdf_types ||= []
    end
    
    # This helps the "new" method to either return an existing element or
    # instead create a new object with the given uri.
    # 
    # We know that this is a hack.
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
      the_source.types << the_source.class.additional_rdf_types
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
    #  * :find_through - accepts and array with an predicate name and an object
    #    value/uri, to search for predicates that match the given predicate/value 
    #    combination
    #  * :type - specifically looks for sources with the given type.
    def self.find(*args)
      prepare_options!(args.last) if(args.last.is_a?(Hash))
      if(args.size == 1 && (uri_s = uri_string_for(args[0])))
        src = super(:first, :conditions => { :uri => uri_s })
        raise(ActiveRecord::RecordNotFound) unless(src)
        src
      else
        super
      end
    end
    
    # The pagination will also use the prepare_options! to have access to the
    # advanced finder options
    def self.paginate(*args)
      prepare_options!(args.last) if(args.last.is_a?(Hash))
      super
    end
    
    
    # This will work in the normal way for database attributes. If the value
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
    # This returns a special object which collects the "inverse" properties 
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
      namesp_uri = N::Namespace[namespace]
      raise(ArgumentError, "Illegal namespace given #{namespace}") unless(namesp_uri)
      namesp_uri ? get_objects_on(namesp_uri + name.to_s) : nil
    end
    
    # Setter method for predicates by namespace/name combination. This will 
    # *add a precdicate triple, not replace one!*
    def predicate_set(namespace, name, value)
      predicate(namespace, name) << value
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
    
    # Gets the types
    def types
      get_objects_on(N::RDF.type.to_s, { :object_type => 'TaliaCore::ActiveSource'}, TypesWrapper)
    end
    
    private
    
    
    # Helper to define a "additional type" in subclasses which will 
    # automatically be added on Object creation
    def has_rdf_type(*types)
      @additional_rdf_types ||= []
      types.each { |t| @additional_rdf_types << t.to_s }
    end
    
    # Returns the related objects on the given predicate, adding the additional
    # conditions to the query.
    def get_objects_on(predicate, conditions = {}, wrapper = SemanticCollectionWrapper)
      conditions.merge!( :predicate_uri => predicate.to_s )
      obs = if(new_record?) # A new record cannot have properties attached
        []
      else
        objects.find(:all, :conditions => conditions )
      end
      wrapper.new(obs, self, predicate)
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
      join << " LEFT JOIN active_sources AS obj_sources ON semantic_relations.object_id = obj_sources.id AND semantic_relations.object_type = 'TaliaCore::ActiveSource'" if(include_rels)
      join << " LEFT JOIN semantic_properties AS obj_props ON semantic_relations.object_id = obj_props.id AND semantic_relations.object_type = 'TaliaCore::SemanticProperty'" if(include_props)
      join
    end
    
    
    # Takes the "advanced" options that can be passed to the find method and
    # converts them into "standard" find options.
    def self.prepare_options!(options)
      check_for_find_through!(options)
      check_for_type_find!(options)
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
        search_prop = (f_through.size > 2) ? f_through[2] : !(obj_val =~ /:/)
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
    
    # Checks for the :type option in the find options. This is the same as
    # doing a :find_through on the rdf type
    def self.check_for_type_find!(options)
      if(f_type = options.delete(:type))
        options[:find_through] = [N::RDF::type, f_type.to_s, false]
        check_for_find_through!(options)
      end
    end
  end
  
end
