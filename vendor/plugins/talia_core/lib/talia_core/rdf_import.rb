module TaliaCore
  
  
  
  # Import RDF data directly into the triple store.
  # This is called to import onotologies and other RDF data.
  class RdfImport
    
    class << self
      
      # Import the given files.
      # The rdf_syntax may be nil. If "auto" is given, it will use a default
      # value for each imported file
      def import(rdf_syntax, files, context=nil)
        puts "Importing #{files.size} files into the triple store."
        
        raise(ArgumentError, "Cannot use context, adapter doesn't support it.") if(context && !adapter.supports_context?)
        
        # check if the connection to te triplestore is ok...otherwise exit the script
        if !adapter
          puts "\nERROR: impossible to open a connection to the triple store. Check your system and your configuration files!\n\n"
          exit(1)
        end

        # try to load every file into the triple store
        files.each do |file|
          import_file(file, rdf_syntax, context)
        end

        adapter.save if(adapter.respond_to?(:save))

        puts "\n--> Importing rdf/rdfs file: complete!\n\n"
      end

      def import_file(file, syntax, context)
        puts "\tLoading: " << file.to_s

        my_context = make_ontology_context(context, file)

        # load rdf/rdfs file into triplestore
        begin
          params = [ file ]
          # Other than the adapter, we prefer rdfxml syntax
          params << ((syntax && syntax != 'auto') ? syntax : 'rdfxml')
          params << my_context if(my_context)
          adapter.load(*params)
        rescue Exception => e
          puts "\tProblem loading #{file.to_s}: (#{e.message}) File not loaded!"
          puts e.backtrace
        end
      end

      # Clear the currently registered ontologies
      def clear_file_contexts
        # Remove all registered contexts
        to_clear = Query.new(N::URI).select(:context).distinct.where(N::TALIA.rdf_context_space, N::TALIA.rdf_file_context, :context).execute
        to_clear.each do |context|
          adapter.clear(context) 
        end
        FederationManager.delete(N::TALIA.rdf_context_space, N::TALIA.rdf_file_context, nil)
      end

      private

      def adapter
        @adapter ||= ConnectionPool.write_adapter
      end

      # Prepare the context for the ontology import. All contexts will be registered
      # to the N::TALIA.rdf_context_space resource
      def make_ontology_context(context, file)
        return unless(context)
        
        raise(ArgumentError, "Empty context") unless(context != '')
        
        file_context = if(context.to_s == 'auto')
          name = URI.encode(File.basename(file, File.extname(file))).gsub(/\./, '_')
          N::URI.new(N::TALIA + name)
        elsif(context)
          N::URI.new(N::TALIA + context)
        end
        
        FederationManager.add(N::TALIA.rdf_context_space, N::TALIA.rdf_file_context, file_context)
        
        file_context
      end
      
    end
  end
end
