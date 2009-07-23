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
    
    extend ActiveSourceParts::ClassMethods
    extend ActiveSourceParts::SqlHelper
    include ActiveSourceParts::PredicateHandler
    extend ActiveSourceParts::PredicateHandler::ClassMethods
    include ActiveSourceParts::Rdf
    
    # Set the handlers for the callbacks defined in the other modules. The
    # order matters here.
    after_save :auto_create_rdf
    after_save :save_wrappers # Save the cache wrappers

    
    # Relations where this source is the subject of the triple
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
      if(db_attr?(attribute))
        super(attribute)
      else
        get_objects_on(attribute)
      end
    end
    alias :get_attribute :[]

    # Assignment to an attribute. This will overwrite all current triples.
    def []=(attribute, value)
      if(db_attr?(attribute))
        super(attribute, value)
      else
        pred = get_attribute(attribute)
        pred.remove
        pred << value
      end
    end

    # Make aliases for the original updating methods
    alias :update_attributes_orig :update_attributes
    alias :update_attributes_orig! :update_attributes!

    # Updates *all* attributes of this source. For the database attributes, this works
    # exactly like ActiveRecord::Base#update_attributes
    #
    # If semantic attributes are present, they will be updated on the semantic store.
    #
    # After the update, the source will be saved.
    def update_attributes(attributes)
      process_attributes(false, attributes) { |db_attrs| super(db_attrs) }
    end

    # As update_attributes, but uses save! to save the source
    def update_attributes!(attributes)
      process_attributes(false, attributes) { |db_attrs| super(db_attrs) }
    end
    
    # Works like update_attributes, but will replace the semantic attributes
    # rather than adding to them.
    def rewrite_attributes(attributes)
      process_attributes(true, attributes) { |db_attrs| update_attributes_orig(db_attrs) }
    end
    
    # Like rewrite_attributes, but calling save!
    def rewrite_attributes!(attributes)
      process_attributes(true, attributes) { |db_attrs| update_attributes_orig!(db_attrs) }
    end
    
    # Helper to update semantic attributes from the given hash. If there is a
    # "<value>" string, it will be treated as a reference to an URI. Hash
    # values may be arrays.
    #
    # If overwrite is set to yes, the given attributes (and only those)
    # are replaced with the values from the hash. Otherwise
    # the attribute values will be added to the existing ones
    def add_semantic_attributes(overwrite, attributes)
      attributes.each do |attr, value|
        value = [ value ] unless(value.is_a?(Array))
        attr_wrap = self[attr]
        attr_wrap.remove if(overwrite)
        value.each { |val |self[attr] << target_for(val) }
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
    
    # True if the given attribute is a database attribute
    def db_attr?(attribute)
      ActiveSource.db_attr?(attribute)
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
    
    # Extracts the semantic attributes from the attribute hash and passes them
    # to add_semantic_attributes with the given overwrite flag. The database
    # flags are then passed to the block.
    def process_attributes(overwrite, attributes)
      attributes = ActiveSource.split_attribute_hash(attributes)
      add_semantic_attributes(overwrite, attributes[:semantic_attributes])
      yield attributes[:db_attributes]
    end
    
    # Creates the target for the given attribute. If the value
    # has the format <...>, it will be returned as an URI object, if it's a normal
    # string it will be returned as a string.
    def target_for(value)
      return value if(value.kind_of?(N::URI) || value.kind_of?(ActiveSource))
      assit_kind_of(String, value)
      value.strip!
      if((value[0..0] == '<') && (value[-1..-1] == '>'))
        value = ActiveSource.expand_uri(value [1..-2])
        val_src = ActiveSource.find(:first, :conditions => { :uri => value })
        if(!val_src)
          value = DummySource.new(value)
          value.save!
        else
          value = val_src
        end
      end
      value
    end

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

    # Remove the inverse properties, to be called before destroy. Doing this
    # through the polymorphic relation automatically could be a bit fishy...
    def remove_inverse_properties
      SemanticRelation.delete_all(["object_type = 'TaliaCore::ActiveSource' AND object_id = ?", self.id])
    end
    
  end
  
end
