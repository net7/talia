module TaliaUtil
  
  # Import module for Talia data contained in YAML files
  class YamlImport
    class << self
      
      # Register the namespaces define in the data file
      def register_namespaces(data)
        if(data["namespaces"])
          data["namespaces"].each do |shortcut, uri|
            if(N::URI.shortcut_exists?(shortcut))
              if(!N::URI[shortcut].to_s == shortcut)
                puts "WARNING: Namespace for #{shortcut} already registered with #{N::URI[shortcut]} instead of #{uri}."
              else
                puts "Namespace #{shortcut} already registered."
              end
            else
              N::Namespace.shortcut(shortcut, uri)
              puts "Registered namespace #{shortcut} for #{uri}"
            end
          end
          data.delete("namespaces")
        end
      end
    
      # Process multiple YAML files
      def import_multi_files(files)
        files.each do |file|
          import_file(file)
        end
      end
    
      # Import the data from a YAML file
      def import_file(datafile)
        data = YAML::load(File.open(datafile))
      
        register_namespaces(data)
      
        progress = ProgressBar.new("Importing", data.size)
      
        puts "Importing data from #{datafile}..."
      
        data.each do |source_name, data_set|
          puts "Processing #{source_name}" if(Util::flag?("verbose"))
          primary_source = data_set.delete("primary_source") == "true" ? true : false
          types = data_set.delete("type")
          types = [types] unless(types.kind_of?(Array))
          types.compact!
          # Create the type uris
          types = types.collect { |type| N::URI.make_uri(type) }
        
          # Create the source
          source = TaliaCore::Source.new(source_name)
          source.types << types
          source.save! # save the thing
        
          # Now add the rdf elements
          data_set.each do |name, value|
            uri = N::URI.make_uri(name, "#")
            value = [value] unless(value.kind_of?(Array))
          
            value.each do |val|
              val = TaliaCore::Source.new(N::URI.make_uri(val)) if(val.index(":"))
              source[uri] << val
            end
          end
        
          source.save! # Save all
        
          progress.inc
        end
      
        progress.finish
        puts "Done"
      end
    end
  end
end
  
