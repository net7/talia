module TaliaCore
  
  # This class describes a source type of sources in the Talia system.
  # A the moment, a source type consists just of a URI and a 
  # short name to access it.
  #
  # To use a SourceType, it needs to be registered like this:
  # SourceType.register(:shortname, "http://blafoo/shortname")
  # The source type will be stored in an internal list,
  # and will be accessible like this:
  # SourceType.Shortname (This constant will return the SourceType object)
  #
  # A source type URI can never be registered twice
  class SourceType
    # The URI that describes the source type
    attr_accessor :uri
    
    # A has that contains all existing source types
    @@type_hash = Hash.new
    
    
    # Registers a new source type in the class. 
    # TODO: This is not thread-safe
    def self.register(symbol, uri)
      current_uri = URI.new(uri)
      current_symbol = symbol.to_s.capitalize
      
      # We don't want any duplicates
      raise(DuplicateIdentifierError, current_symbol) if(self.const_defined?(current_symbol))
      raise(DuplicateIdentifierError, current_uri.to_s) if(@@type_hash[current_uri.to_s])
      
      @@type_hash[current_uri.to_s] = current_symbol
      self.const_set(current_symbol, current_uri)
    end
    
    protected
    
    # FIXME: Implementation
    # When a new object is created, it will be checked if it already
    # exists.
    # TODO: This is not thread safe!
    def initialize(uri)
      @uri = URI.new(uri.to_s)
      raise(DuplicateIdentifierError, uri) if(@@type_hash.values.include?(@uri))
    end
    
  end
end