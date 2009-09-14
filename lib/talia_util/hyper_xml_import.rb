require 'uri'
require 'open-uri'
require 'net/http'
require 'rexml/document'

module TaliaUtil

  # Imports the XML files which are produced by the old Hyper software
  class HyperXmlImport
    class << self
      
      def options
        @options ||= {}
      end
      
      # Set the authentication credentials for http (if needed)
      def set_auth(user, password)
        @user = user
        @password = password
      end
      
      # Opens the given uri, and returns the content as a string. The 
      # uri may be a http uri, a file:/// uri or a simple filename
      def read_from(uri)
        
        # The "file://" type is not natively recognized. If it's there, we
        # strip it to get the real file name
        uri.gsub!(/^\s*file:\/\//, '') if(uri.kind_of?(String))

        uri_plus_opts = [ uri ] # parameters for the open method
        if(@user || @password)
          uri_plus_opts << { :http_basic_authentication => [@user, @password] } if uri.match('http://')
        end
        
        # Now we can just try to read from the URI
        open(*uri_plus_opts) { |stream| stream.read }
      end
      
    end
  end
  
end
