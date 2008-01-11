require 'uri'
require 'net/http'
require 'rexml/document'

require 'talia_util/hyper_import/importer'

module TaliaUtil

  # Imports the XML files which are produced by the old Hyper software
  class HyperXmlImport
    class << self
      
      # Import a single source from XML. The xml_source is the source of the
      # element to import. If this is an URL, it will be used to fetch the
      # information from the web. 
      def import_source(xml_source)
        doc = open_uri(xml_source) # Open the XML document
        doc.root.elements.each 
      end
      
      protected
      
      # Opens an XML document from the given URI. Returns a REXML::Document
      def open_uri(uri)
        # Check if we have an URI string for files or http. If it's a file,
        # we remove the 'file://' from the front to get the filename
        if(uri.kind_of?(String))
          if(uri =~ /^\s*http:\/\//)
            uri = URI.parse(uri)
          else
            uri.gsub!(/^\s*file:\/\//, '')
          end
        end
        
        source = nil
        # Now, if we have an HTTP URI, let's connect to the server
        if(uri.kind_of?(URI::HTTP))
          response = Net::HTTP.get_response(uri)
          raise(Net::HTTPFatalError, "Cannot open #{uri}") unless(response.kind_of?(Net::HTTPSuccess))
          source = response.body
        elsif(uri.kind_of?(String))
          source = File.open(uri, "r")
        else
          raise(URI::Error, "Unknown Source #{uri.to_s}")
        end
        
        raise(RuntimeError, "Could not create data source from #{uri}")
        REXML::Document.new(source)
      end
      
    end
  end
  
end
