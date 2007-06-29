module TaliaCore
  require 'active_support'
  
  # This contains the main configuration for the Talia system
  # At the moment this contains just a bunch of configuration variables
  class Configuration
    
    # The name of the local node
    @@local_node = URI.new('http://www.dummyhost.useless/')
    cattr_accessor :local_node
    
  end
  
end