require 'objectproperties' # Includes the class methods for the object_properties
require 'local_store/source_record'
require 'active_rdf'

module TaliaCore
  
  # This represents a Source in the Talia core system.
  class Source
    # The elements tagged with object_property will be properties
    # passed to the local database. These elements need to be
    # in sync with the database schema
    #
    # TODO: We will need some validation for this
    # IDEA: In future version, we could try to hook into the schema
    #       to do this automatically
    
    # The URI that idefifies the source
    object_property :uri
    
    # This a descriptive name
    object_property :name
    
    # This indicates if the source is a primary source in this library
    object_property :primary_source
    
    # The work flow state
    object_property :workflow_state
  
    
    # Creates a new Source from a uri
    # If a source with the given URI already exists, this will throw an error
    def initialize(uri, *types)
      # First build a clean uri
      my_uri = N::URI.new(uri)
      
      raise(DuplicateIdentifierError, "Source already exists:" + uri) if(SourceRecord.exists?(uri))
      
      # Contains the interface to the part of the data that is
      # stored in the database
      @source_record = SourceRecord.new(uri)
      
      # Contains the interface to the ActiveRDF 
      @rdf_resource = RDFS::Resource.new(uri.to_s)
      
      # Contains the type objects for the source
      @source_types = Array.new
      
      
      # Insert the types
      for type in types do
        type_uri = N::SourceClass.new(type)
        @source_record.types.push(SrecordType.new(type_uri))
        @source_types.push(type_uri)
      end
    end
    
    
    # Tries to load the given source object
    def load(uri)
      
    end
    
    # Indicates if this source belongs to the local store
    def local
      uri.local?
    end
    
    # Check if this object is valid.
    # This checks if all constraints for the object properties
    # and the RDF properties are met.
    def validates?
      # TODO: Implementation missing, the follwing is sample code
      @object_store.validates? && @rdf_store.validates?
    end
    
    # Saves the data for this resource
    # TODO: Check if we need to do anything transaction-like!!!
    def save()
      # TODO: Implementation mising, the following is just an example
      # TODO: Add permission checking
      @object_store.save()
      @rdf_store.save()
    end
    
    # Returns a list of data objects, or nil if the Source has no data
    # TODO: Check: Note that the data will be stored in the object_store,
    #       but is not an object_property. This is because this is
    #       something that requires extra handling.
    def data
      # TODO: Implementation missing
      # TODO: Permission checks for some data types?
    end
    
    
    # Initializer for the database store
    def self.storage_init
      # FIXME: Implementation missing
    end
    
    # Find Sources in the system
    # TODO: Needs specification!
    def self.find(params)
      # TODO: Implementation. The following is just an example
      ObjectStore.find(params)
    end
    
    # Check if a Source exists in the system
    # TODO: See find
    def self.exists?(params)
      # TODO: Implementation. The following is just an example
      ObjectStore.exists?(params)
    end
    
    protected
    
    # Missing methods: We assume that all calls that are not handled
    # explicitly are property requests that can be answered by
    # the RDF store.
    # 
    # There are 3 possibilities here, which are processed in that order:
    # 
    # 1. The method name is a shortcut for a PredicateType. In that
    #    case, we use that predicate for the resource. We don't expect
    #    any arguments.
    # 2. The method name is the shortcut for a Namespace. In that case,
    #    we expect an argument which can be appended to the Namespace
    #    as a string
    # 3. The method name is a shortcut for a generic URI, in which case we
    #    use it with or without an argument
    # 4. The method name is unknown, in which case we use it in the
    #    default namespace.
    def method_missing(method_name, *args)
      # TODO: This is just a sample, we need special handling
      #       here for some cases
      # TODO: ActiveRDF just returns "nil" if it finds nothing.
      #       There is a reason for this, but it may not be so
      #       good here. Maybe there's a way to intelligently 
      #       raise errors?
      # TODO: Add permission checking for all updates to the model
      # TODO: Add permission checking for read access?
      @rdf_resource.send(method_name, args)
    end
    
    # Create find parameters for SourceRecord.find() from
    # the parameters that were passed to the find method of
    # this class
    
  end
end