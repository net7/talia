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
  class DummyHandler
    
    # Create the new handler
    def initialize(namespace, subject)
      assit_kind_of(N::URI, namespace)
      assit_kind_of(TaliaCore::Source, subject)
      
      @namespace = namespace.to_s
      @subject = subject
    end
    
    # Catch the invocations
    def method_missing(method, *args)
      # read value
      raise(SemanticNamingError, "Wrong number of arguments") if(args.size != 0)
      @subject[@namespace + method.to_s]
    end
    
    # remove the type call
    private :type
  end
end