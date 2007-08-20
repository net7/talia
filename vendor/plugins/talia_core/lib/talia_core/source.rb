# require 'objectproperties' # Includes the class methods for the object_properties
require 'local_store/source_record'
require 'active_rdf'
require 'semantic_naming'
require 'dummy_handler'
require 'rdf_resource_wrapper'

module TaliaCore
  
  # This represents a Source in the Talia core system.
  class Source
    
    # Creates a new Source from a uri
    # If a source with the given URI already exists, this will load the given
    # source (no types can be given in that case)
    def initialize(uri, *types)
      
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
        # FIXME: RDF connection isn't there yet
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
    # TODO: Needs specification!
    def self.find(*params)
      find_result = nil
      
      # If we have one parameter, it will be the URL 
      # of the item to load
      if(params.size == 1)
        uri = build_query_uri(params[0].to_s)
      
        source_record = SourceRecord.find_by_uri(uri)
        find_result = Source.new(source_record.uri)
      else
        # FIXME: Complex find still missing
        sassert(false, "Find not yet implemented")
      end
      
      sassert_type(find_result, Source)
      return find_result
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
    
    # Accessor that allows to lookup a namespace/name combination
    def predicate(namespace, name)
      namesp_uri = N::Namespace[namespace]
      
      # Only return something if the namespace exits.
      namesp_uri ? self[namesp_uri + name.to_s] : nil
    end
    
    # Setter method for predicates by namespace/name combination
    def predicate_set(namespace, name, value)
      namesp_uri = N::Namespace[namespace]
      
      # Check if namespace exists
      namesp_uri ? self[namesp_uri + name.to_s] = value : false
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
          for type in @source_record.source_type_records do
            builder.type(type.uri.to_s)
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
    
    
    # Build an uri from a string that was given from a query.
    # If this already is a uri, it will just be returned. 
    # If this is not an URI, it will return a URI with the given name in the 
    # local namespace
    def self.build_query_uri(orig_string)
      uri = orig_string.to_s
      
      if(!N::URI.is_uri?(uri))
        uri = (N::LOCAL + uri).to_s
      end
      
      return  uri
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
        @source_record.source_type_records.push(SourceTypeRecord.new(type))
      end
    end
    
    # Loads an existing record into the system
    def load_record(existing_record)
      sassert_type(existing_record, SourceRecord)
      sassert_not_nil(existing_record.uri)
      
      # Our local store is the record given to us
      @source_record = existing_record
      
      # Create the RDF object
      @rdf_resource = RdfResourceWrapper.new(existing_record.uri.to_s)  
    end
    
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
        @rdf_resource[predicate.to_s] = args[-1]
      else
        @rdf_resource[predicate.to_s]
      end
    end
    
    
  end
end
