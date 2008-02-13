require 'uri'
require 'open-uri'
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
      #
      # The base_uri is the uri where the import data is retrieved. The 
      # list_location and sig_request are additional uri parts that are 
      # appended to the URI to retrieve the list of all sigla and the
      # documents themselves. 
      #
      # To retrieve a document, the siglum from the list xml will be appended
      # to base_uri + sig_request.
      def import(base_uri, list_location = "?getList=all", sig_request = "?get=")
        puts "Importing from URI: #{base_uri}. Fetching list from #{base_uri + list_location}"
        # open the document with the sigla to import
        import_doc = REXML::Document.new(read_from(base_uri + list_location))
        puts "Fetched list, importing #{import_doc.root.elements.size} elements"
        progress = ProgressBar.new("Importing", import_doc.root.elements.size)
        
        import_doc.root.elements.each("siglum") do |siglum|
          begin
            progress.inc
            sig_uri = base_uri + sig_request + siglum.text.strip
            HyperImporter::Importer.import(REXML::Document.new(read_from(sig_uri)))
          rescue Exception => e
            puts("Error when importing #{siglum}: #{e}")
          end
        end
        
        progress.finish
        puts "Import complete."
        
      end
      
      protected
      
      # Opens the given uri, and returns the content as a string. The 
      # uri may be a http uri, a file:/// uri or a simple filename
      def read_from(uri)
        
        # The "file://" type is not natively recognized. If it's there, we
        # strip it to get the real file name
        uri.gsub!(/^\s*file:\/\//, '') if(uri.kind_of?(String))
        
        # Now we can just try to read from the URI
        open(uri) { |stream| stream.read }
      end
      
    end
  end
  
end
