module TaliaCore
  
  # Helper methods for the Talia core classes
  class CoreHelper
    class << self
      
      # Get an URI string from the given string in ns:name notation
      def make_uri(str, separator = ":")
        type = str.split(separator)
        type = [type[1]] if(type[0] == "")
        if(type.size == 2)
          N::URI[type[0]] + type[1]
        else
          N::LOCAL + type[0]
        end
      end
    
    end
  end
end
