module TaliaCore
  
  # This class contains basic functionality for URIs
  class URI
    # This is the uri string which is contained in this
    # object
    attr_accessor :uri_s
    
    # Create a new URI
    def initialize(uri_s)
      sassert_type(uri_s, String)
      
      @uri_s = uri_s
    end
    
    # Compare operator
    def ==(object)
      return object.uri_s == @uri_s if(object.kind_of?(URI))
      return object == @uri_s if(object.kind_of?(String))
      return false
    end
    
    # Checks if the current URI is local
    def local?
      Configuration.local_node.domain_of?(self)
    end
    
    # Redirect for checking if this is remote
    def remote?
      !local?
    end
    
    # String representation is the uri itself
    def to_s
      uri_s
    end
    
    # This creates a helpers for a nice notation of
    # like my_domain::myid
    def const_missing(klass)
      return @uri_s + klass.to_s
    end
    
    # See const_missing
    def method_missing(method, *args)
      # Quick sanity check: args make no sense for this
      raise(NoMethodError, "Undefined method: " + method.to_s) if(args && args.size > 0)    
      
      return @uri_s + method.to_s
    end
    
    # Is true if this object describes the domain of the
    # given uri, and the given uri is a resource in that
    # domain
    def domain_of?(uri)
      if(uri.kind_of?(String))
        uri_s = uri
      else
        sassert_type(uri, URI)
        uri_s = uri.uri_s
      end
      
      (uri_s =~ /\A#{@uri_s}\w*/) != nil
    end
  end
end