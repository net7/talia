module TaliaUtil
  
  
  
  # Import RDF data directly into the triple store.
  # This is called to import onotologies and other RDF data.
  class RdfImport
    
    class << self
      
      # Import the given files.
      # The rdf_syntax may be nil or "auto" for the default value.
      def import(rdf_syntax, files)
        puts "Importing #{files.size} files into the triple store."
        
        adapter = ConnectionPool.write_adapter
        
        # check if the connection to te triplestore is ok...otherwise exit the script
        if !adapter
          puts "\nERROR: impossible to open a connection to the triples store. Check your system and your configuration files!\n\n"
          exit(1)
        end
        
        # try to load every file into the triple store
        files.each do |file|
          puts "\tLoading: " << file.to_s
          
          # load rdf/rdfs file into triplestore
          begin
            if(rdf_syntax && rdf_syntax != "auto")
              adapter.load(file, rdf_syntax)
            else
              adapter.load(file)
            end
          rescue
            puts "\tProblem loading: " << file.to_s << ". File not loaded!"
          end
        end
        
        adapter.save if(adapter.respond_to?(:save))
        
        puts "\n--> Importing rdf/rdfs file: complete!\n\n"
      end
      
    end
  end
end
