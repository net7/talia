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
      assit_type(uri, N::URI)
      assit_type(rdf_resource, RdfResourceWrapper)
      
      @uri = uri.to_s
      @rdf_resource = rdf_resource
    end
    
    # Catch the invocations
    def method_missing(method, *args)
      if method.to_s[-1..-1] == '='
        # set value
        raise(SemanticNamingError, "Wrong number of arguments") if(args.size != 1)
        @rdf_resource[@uri + method.to_s[0..-2]] << args[0]
      else
        # read value
        raise(SemanticNamingError, "Wrong number of arguments") if(args.size != 0)
        @rdf_resource[@uri + method.to_s] 
      end
    end
  end
end