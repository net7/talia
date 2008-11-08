require 'rexml/document'

module TaliaUtil
  # Imports the sources from a local XML file 
  class XmlImport
    class << self
      
      def options
        @options ||= {}
      end
      def import(xml_file)   
        assit(File.exist?(xml_file))
        # Read the file containing the XML of the sources to import.
        # XML File must have a <sources> root element and each element to 
        # import must be inside a <source> element
        xml = File.open(xml_file, "r").read()
        elapsed = Benchmark.realtime do
          puts "Importing from file: #{xml_file}."
          import_doc = REXML::Document.new(xml)
          size = import_doc.root.elements.size unless import_doc.root.elements['source'].nil?
          abort("No <source> element in #{xml_file} file found. Exiting") if size.nil?
          puts "Fetched list, importing #{size} elements"
          progress = ProgressBar.new("Importing", size)
        
          # Toggle the progressbar to force it active
          progress.set(size/100)
        
          import_doc.root.elements.each("source") do |source|
            progress.inc
            begin
              TaliaUtil::HyperImporter::Importer.import(REXML::Document.new(source.elements[1].to_s), options)
            rescue Exception => e
              $stderr.puts("Error when importing from #{xml_file}: #{e}\nBacktrace: #{e.backtrace.join("\n")}")
            end
          end
          progress.finish
        end
        puts "Import completed in sec %.2f" %elapsed
      end
    end
  end
end

      