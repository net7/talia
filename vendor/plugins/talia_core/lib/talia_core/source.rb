require 'objectproperties' # Includes the class methods for the object_properties
require 'active_rdf'

module TaliaCore
  
  # This represents a Source in the Talia core system.
  class Source
    # object_property defines the properties that are "owned"
    # by this object (instead of being RDF properties)
    # TODO: (Implementation hint) 
    # Getter and setter calls for these properties could
    # be passed directly to the @object_store
    
    # The URI that idefifies the source
    object_property :uri
    
    # The work flow state
    object_property :workflow_state
  
  
    # Contains a reference to the RDF storage object
    # for this source. Usually this will be an RDFS::Resource
    @rdf_store 
    
    # Contains an object that represents the storage
    # this object itself. This may go to a SQL backend
    # or a REST service, for example
    @object_store
    
    # Creates a new Source from a uri
    def initialize(uri)
      # TODO: Implementation missing
      # 1. Check if local or remote, and create @object_store
      # 2. Check if this Source already exists
      # TODO: Behaviour if source exists?
      # 3. Initialize @rdf_store
      # 4. Check Type information
    end
    
    # Indicates if this source belongs to the local store
    def local
      # TODO: Implementation
      # Check if the uri is local
    end
    
    # Returns a list of SourceType objects that identify
    # the source's type
    def source_types
      # TODO: Implementation
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
    
    # Find Sources in the system
    # TODO: Needs specification!
    self.find(params)
      # TODO: Implementation. The following is just an example
      ObjectStore.find(params)
    end
    
    # Check if a Source exists in the system
    # TODO: See find
    self.exists?(params)
      # TODO: Implementation. The following is just an example
      ObjectStore.exists?(params)
    end
    
    protected
    
    # Missing methods: We assume that all calls that are not handled
    # explicitly are property requests that can be answered by
    # the RDF store.
    def method_missing(method_name, *args)
      # TODO: This is just a sample, we need special handling
      #       here for some cases
      # TODO: ActiveRDF just returns "nil" if it finds nothing.
      #       There is a reason for this, but it may not be so
      #       good here. Maybe there's a way to intelligently 
      #       raise errors?
      # TODO: Add permission checking for all updates to the model
      # TODO: Add permission checking for read access?
      @rdf_store.send(method_name, args)
    end
  end
end