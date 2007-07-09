module TaliaCore
  require 'active_support'
  
  # This contains the main configuration for the Talia system
  # At the moment this contains just a bunch of configuration variables
  class Configuration
    
    # Set the local namespace
    def self.local_name=(local_name)
      N::Namespace.shortcut(:local, local_name)
    end
    
    # return the local namespace
    def self.local_name
      if(N.const_defined?(:LOCAL))
        N::LOCAL
      else
        nil
      end
    end
    
  end
  
end