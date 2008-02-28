require 'active_rdf'
require 'semantic_naming'
require 'assit'
require 'errors'

module TaliaCore
  
  # This is an internal class for "dummy handler invocations" on sources
  # The problem is that invocations like source.namespace::name are
  # evaluated to (source.namespace).name 
  # This means that source.namespace must return an object on which
  # "name" can be called with the desired effect. This is the "dummy handler"
  # TODO: This duplicates functionality from ActiveRDF
  class DummyHandler
    
    # Create the new handler
    def initialize(uri, rdf_resource)
      assit_kind_of(N::URI, uri)
      assit_kind_of(RdfResource, rdf_resource)
      
      @uri = uri.to_s
      @rdf_resource = rdf_resource
    end
    
    # Catch the invocations
    def method_missing(method, *args)
      # read value
      raise(SemanticNamingError, "Wrong number of arguments") if(args.size != 0)
      @rdf_resource[@uri + method.to_s]
    end
    
    # remove the type call
    private :type
  end
end