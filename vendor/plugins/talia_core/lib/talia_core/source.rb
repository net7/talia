# require 'objectproperties' # Includes the class methods for the object_properties
require 'local_store/source_record'
require 'active_rdf'
require 'semantic_naming'
require 'dummy_handler'
require 'rdf_resource_wrapper'
require 'source_property_list'
require 'type_list'

module TaliaCore
  
  # This represents a Source in the Talia core system.
  #
  # Since data for the Source exists both in the database and in the RDF store, the 
  # handling/saving of data is a bit peculiar at the moment (subject to change in the future):
  #
  # * When a new Source is created, the database record is save *immediately* with 
  #   default values
  # * RDF properties are always written *immediately*
  # * Database properties are *only written when the save method is called*
  # * To ensure that the data is written, the save method should be called as 
  #   necessary.
  class Source
    
    # Creates a new Source from a uri
    # If a source with the given URI already exists, this will load the given
    # source (no types can be given in that case)
    #
    # If a new record is created, the empty record will be *immediately* saved to the database.
    # This is to avoid "orpahn" RDF records.
    def initialize(uri, *types)
      return load_record(uri) if(uri.is_a?(SourceRecord)) # Shortcut if a record is given directly
      
      existing_record = nil
      
      uri = Source.build_query_uri(uri)
      
      if(SourceRecord.exists_uri?(uri))
        if(types && types.size > 0)
          raise(DuplicateIdentifierError, 
            "Source already exists, cannot create with new type information: " + uri)
        end
        existing_record = SourceRecord.find_by_uri(uri)
      end
      
      if(existing_record)
        load_record(existing_record)
      else
        create_record(uri, types)
      end
    end
    
    # Get the id for this record (equals to it's local name)
    def id
      uri.local_name
    end
    
    # Alias for id, used by Rails magic
    alias_method :to_param, :id
    
    # Indicates if this source belongs to the local store
    def local
      uri.local?
    end
    
    # Check if this object is valid.
    # This checks if the constraints for the Source are met.
    # Currently this only checks the constraints on the database
    # object.
    def valid?
      @source_record.valid? 
    end
    
    # Saves the data for this resource
    def save()
      # TODO: Add permission checking
      
      # We wrap this in a transaction: If the RDF save fails,
      # the database save will be rolled back
      SourceRecord.transaction do
        @source_record.save()
        @rdf_resource.save()
      end
    end
    
    # Saves the data for this resource and raises error on Failure
    def save!()
      # TODO: Add permission checking
      
      # We wrap this in a transaction: If the RDF save fails,
      # the database save will be rolled back
      SourceRecord.transaction do
        @source_record.save!()
        @rdf_resource.save()
      end
    end
    
    # Returns a list of data objects, or nil if the Source has no data
    # TODO: Check: Note that the data will be stored in the object_store,
    #       but is not an object_property. This is because this is
    #       something that requires extra handling.
    def data
      # FIXME: Implementation missing
      # TODO: Permission checks for some data types?
    end
    
    # Accessor for the error messages (after validation)
    # At the moment, these are only the object store messages
    def errors
      return @source_record.errors
    end
    
    
    # Find Sources in the system
    # If just a single parameter is given, then we assume that this is
    # the URI of a source. If the paramter is not an URI, we assume that
    # it's the name of a local Source and prepend the local namespace.
    #
    # The method checks if a query can be answered from the database alone, or if an
    # RDF lookup is necessary. If an RDF lookup is neccesary *only* Sources that exist
    # in the database are returned. This has an effect on the :limit and :offset paramemters:
    # since they are passed on to the RDF store, they method may return less elements 
    # if some of the Sources found in the RDF query are not in the database!
    #
    # The method can be used in a way similiar to the <tt>ActiveRecord::find</tt> method:
    #
    # * Find by url: You can give one or moren urls, and the method will either return a
    #   Source object (for a single url) or an Array of Source objects (for multiple urls)
    #   If not all of the given urls exist, an error will be raised.
    # * Find first: This will return the first record that is matched by the options given.
    #   remember that this may <b>not</b> be the same as the first record returned by SQL for that
    #   parameters. This is equivalent to :limit => 1 and :offset => 0
    # * Find all: This will return all records matched by the given options.
    #
    # Currently, the following options are supported:
    #
    # * <tt>:type</tt>: Give one or more Source types, the results will only contain the given types
    # * <tt>:limit</tt>: Limits the size of the result set to the given number of elements.
    # * <tt>:offset</tt>: The number of the first element that will be returned
    # * <tt>predicate</tt>: Returns only records where the "predicate" has the given value. The predicate
    #   (hash key) may be either an URI string or an N::URI object.
    #
    # Examples for find by uri:
    #   Source.find("http://www.domain.org/thesource") # Finds one uri
    #   Source.find("http://www.domain.org/somesource", "http://www.domain.org/othersource") # Finds multiple uris
    #   Source.find("document") # Finds a resource in the local namespace
    #   Source.find(N::FOOBAR + "id") # Uses the dynamic naming to construct the uri
    #
    # Expamples for find first:
    #   Source.find(:first) # Just selects the "first" source
    #   Source.find(:first, :type => N::DEFAULT + "book") # Select by type
    #
    # Examples for find all:
    #   Source.find(:all) # Finds all Sources
    #   Source.find(:all, :type => N::DEFAULT::book) # Find all Sources of the given type
    def self.find(*params)
      raise QueryError("No query string given") unless(params.size > 0)
      
      first_param = params.first
      find_result = nil
      
      # If the first param is a String or URI, we query for the given URIs
      if(first_param.is_a?(String) || first_param.kind_of?(N::URI))
        uris = params.collect { |param| build_query_uri(param) }
        return load_from_records(SourceRecord.find_by_uri(uris))
      end
      
      # Check if there's an object Hash, otherwise use empty options
      options = params.last.is_a?(Hash) ? params.pop : {}
      
      if(is_rdf_query(options))
        # Do an RDF query
        case(first_param)
        when :first
          options[:limit] = 1
          options[:offset] = 0
        when :all
        else
          raise QueryError("Illegal query parameters")
        end
        find_result = load_from_resources(RdfResourceWrapper.find_from_hash(options))
        # For :first find, just return the first element instead of the array
        find_result = find_result[0] if((first_param == :first) && (find_result.size == 1))
      else
        # Do an database query
        sources = SourceRecord.find_by_hash(first_param, options)
        if(sources.kind_of?(SourceRecord))
          find_result = Source.new(sources)
        else
          find_result = sources.collect{ |record| Source.new(record) }
        end
      end
            
      sassert(find_result.is_a?(Source) || find_result.is_a?(Array))
      find_result
    end
    
    # Checks if a source with the given uri exists in the system
    def self.exists?(uri)
      # A source exists if the respective record exists in the
      # database store
      uri = build_query_uri(uri)
      return SourceRecord.exists_uri?(uri)
    end
    
    # Returns an array of the predicates that are directly defined for this
    # Source. This will return a list of URIs that will access valid 
    # attributes on this Source.
    def direct_predicates
      @rdf_resource.direct_predicates
    end
    
    # Returns a TypeList with the types of this Source
    def types
      @rdf_resource.types
    end
    
    # Attribute reader, for compatibility with the ActiveRecord API
    # If the given name is a database field, the called will be
    # passed to the database. Otherwise, this will assume that 
    # the parameter is the URI of a RDF property.
    def [](attribute)
      attr = nil
      
      if(@source_record.attribute_names.index(attribute.to_s))
        attr = @source_record[attribute.to_s]
      else
        attr = @rdf_resource[attribute.to_s]
      end
      
      attr
    end
    
    # Assignment to the the array-type accessor
    def []=(attribute, value)
      if(@source_record.attribute_names.index(attribute.to_s))
        @source_record[attribute.to_s] = value
      else
        @rdf_resource[attribute.to_s] = value
      end
    end
    
    # Accessor that allows to lookup a namespace/name combination. This works like
    # the [] method: It will return a SourcePropertyList
    def predicate(namespace, name)
      namesp_uri = N::Namespace[namespace]
      
      # Only return something if the namespace exits.
      namesp_uri ? self[namesp_uri + name.to_s] : nil
    end
    
    # Setter method for predicates by namespace/name combination. This works like
    # the = operator for a property: *It will add a precdicate triple, not replace one!*
    def predicate_set(namespace, name, value)
      namesp_uri = N::Namespace[namespace]
      
      # Check if namespace exists
      namesp_uri ? self[namesp_uri + name.to_s] << value : false
    end
    
    # Creates a sensible XML representation of the Source
    def to_xml
      xml = String.new
      builder = Builder::XmlMarkup.new(:target => xml, :indent => 2)
      
      # Xml instructions (version and charset)
      builder.instruct!
      
      builder.source(:primary => primary_source) do
        builder.id(@source_record.id, :type => "integer")
        builder.uri(uri.to_s)
        
        # Add the types to the XML
        builder.types() do
          for type in @rdf_resource.types do
            builder.type(type.to_s)
          end
        end
        
        # Add the existing predicates to the XML
        builder.activePredicates do
          for predicate in direct_predicates do
            builder.predicate(predicate.to_s)
          end
        end
      end
      
      xml
    end
    
    protected
    
    
    # Class methods
    class << self
      
      # This examines a query hash for the find method, and returns true if the
      # given query can be answered only from the RDF store
      #
      # If the method returns false, the query can be answered from the database
      # alone
      def is_rdf_query(query_options)
        sassert_type(query_options, Hash)
        
        # Try to find a thing that is neither a special keyword (e.g. :limit)
        # nor a database column
        query_options.keys.detect do |property|
          found = (property != :limit)
          found &&= (property != :offset)
          found &&= (SourceRecord.column_names.index(property.to_s) == nil)
        end
      end
      
      
      # Build an uri from a string that was given from a query.
      # If this already is a uri, it will just be returned. 
      # If this is not an URI, it will return a URI with the given name in the 
      # local namespace
      def build_query_uri(orig_string)
        uri = orig_string.to_s
        
        if(!N::URI.is_uri?(uri))
          uri = (N::LOCAL + uri).to_s
        end
        
        return  uri
      end
      
       # Loads a list of existing records into the system. This will
      # return an Array of Source objects, the records can be given
      # as a list of SourceRecord objects, or as a single Array.
      def load_from_records(*existing_records)
        existing_records = existing_records[0] if(existing_records[0].kind_of?(Array))
        
        existing_records = existing_records.collect { |record| Source.new(record) }
        # flatten the array if neccessary
        existing_records.size == 1 ? existing_records[0] : existing_records
      end
      
      # Loads a list of Sources from a collection of RDFS::Resource object
      # (or RdfResourceWrapper objects). If the corresponding database entry
      # does not exist, the element will be discarded.
      def load_from_resources(*existing_resources)
        existing_resources = existing_resources[0] if(existing_resources[0].kind_of?(Array))
        
        existing_resources = existing_resources.find_all { |resource| SourceRecord.exists_uri?(resource.uri) }
        existing_resources.collect {|resource| Source.new(resource.uri) }
      end
      
    end
    
    # End of class methods
  
     # Loads an existing record into the system
    def load_record(existing_record)
      sassert_type(existing_record, SourceRecord)
      sassert_not_nil(existing_record.uri)
      
      # Our local store is the record given to us
      @source_record = existing_record
      
      # Create the RDF object
      @rdf_resource = RdfResourceWrapper.new(existing_record.uri.to_s)  
    end
  
    # Creates a brand new Source object
    def create_record(uri, types)
      
      # Contains the interface to the part of the data that is
      # stored in the database
      @source_record = SourceRecord.new(uri.to_s)
      
      # Contains the interface to the ActiveRDF 
      @rdf_resource = RdfResourceWrapper.new(uri.to_s)
      
      # Insert the types
      for type in types do
        @rdf_resource.types << type
      end
      
      # Save blank record.
      @source_record.primary_source = false
      @source_record.workflow_state = -1
      @source_record.save!
      
    end
    
    # END OF CLASS METHODS
    
    # Missing methods: This first checks if the method called 
    # corresponds to a valid database attribute. In this case,
    # the call will be passed to the database.
    #
    # Otherwise, the call goes to the RDF store, as explained below.
    # 
    # There are 3 possibilities for RDF, which are processed in that order:
    # 
    # 1. The method name is a shortcut for a PredicateType. In that
    #    case, we use that predicate for the resource. We don't expect
    #    any arguments.
    #    OR
    #    The method name is a shortcut for a generic URI, in which case we
    #    use it like a predicate
    # 2. The method name is the shortcut for a Namespace. In that case,
    #    we expect an argument which can be appended to the Namespace
    #    as a string
    # 3. The method name is unknown, in which case we use it in the
    #    default namespace.
    def method_missing(method_name, *args)
      # TODO: Add permission checking for all updates to the model
      # TODO: Add permission checking for read access?
      
      update = method_name.to_s[-1..-1] == '='
      shortcut = if update 
                     method_name.to_s[0..-2]
                   else
                     method_name.to_s
                   end
      
      arg_count = update ? (args.size - 1) : args.size
      
      # Check if this call should go to the db
      if(@source_record.attribute_names.index(shortcut.to_s))
        if(update)
          return @source_record[shortcut.to_s] = args[-1]
        else
          return @source_record[shortcut.to_s]
        end
      end
      
      # Check for associated database records
      # This has to be checked/called "manually" because the
      # associated types are not properties of the ActiveRecord
      if(assoc = SourceRecord.reflect_on_association(shortcut.to_sym))
        case assoc.macro
        when :has_many
          return @source_record.send(shortcut.to_s)
        when :has_one
          if(update)
            return @source_record.send(method_name.to_s, args[0])
          else
            return @source_record.send(shortcut.to_s)
          end
        else
          sassert(false, "Invalid association type")
          return false
        end
      end
      
      # Otherwise, check for the RDF predicate
      registered = N::URI[shortcut.to_s]
      predicate = nil
      
      if(!registered)
        # Possibility 4.
        predicate = N::DEFAULT + shortcut.to_s
      elsif(registered.kind_of?(N::Namespace))
        # Possibility 2.
        raise(SemanticNamingError, "Namespace invoked incorrectly") if(arg_count != 0)
        # Return "dummy handler" that will catch the namespace::name invocation
        return DummyHandler.new(registered, @rdf_resource)
      elsif(registered.kind_of?(N::SourceClass))
        raise(SemanticNamingError, "Can't use source class as a predicate.")
      elsif(registered.kind_of?(N::URI))
        # Possibility 1.: Predicate or generic URI
        raise(SemanticNamingError, "No additional parameters can be given with predicate") if(arg_count != 0)
        predicate = registered
      else
        # Error: Wrong type
        raise(SemanticNamingError, "Unexpected type in semantic naming")
      end
      
      if update
        @rdf_resource[predicate.to_s] << args[-1]
      else
        @rdf_resource[predicate.to_s]
      end
    end
    
    
  end
end
