require 'yaml'

module TaliaUtil
  module Configuration
    
    # This is an object representation of a configuration file, the elements
    # of the file can be directly accessed using dynamic getters/setters on the
    # the class.
    class ConfigFile
      
      # Initialize from the given template
      def initialize(template)
        @config_doc = YAML::load_file(template)
      end
      
      # Write the configuration to the given file
      def write(file)
        open(file, 'w') { |io| io.puts(@config_doc.to_yaml) }
      end
      
      # Automatically creates "accessors" for the config properties.
      def method_missing(method, *params)
        method = method.to_s
        assign = method[-1..-1] == '=' # True if last char is a =
        
        result = nil
        
        if(assign)
          return super if(params.size != 1)
          result = @config_doc[method[0..-2]] = params[0]
        else
          return super if(params.size != 0)
          result = @config_doc[method]
        end
        
        result
      end
      
      
      
    end
    
  end
end
