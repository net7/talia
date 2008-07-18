require 'FileUtils'

module TaliaUtil
  
  # Import data files into the Talia store. This can be used to bootstrap
  # simple installations
  class DataImport
    
    class << self
  
      # Import files with the given type. This is a simple import feature,
      # it's assumed that the file (without extension is named like the
      # Source it should be assigned to.
      def import(files, type)
    
        # First get the class for the data type and the directory
        data_klass = get_data_class(type)
        replace = ENV['replace_files'] && (ENV['replace_files'] == "yes")
    
        progress = ProgressBar.new("Importing #{data_klass}", files.size)
        not_found = []
        created = 0
    
        files.each do |file|
          # Get the basename without extension and additions. This strips off
          # everything after the first point or - character. Examples:
          # book.html
          # book-picture.jpg
          # => Will all be assigned to "book"
          name = File.basename(file).gsub(/[-|\.].+$/, '')
          if(TaliaCore::Source.exists?(name))
            src = TaliaCore::Source.find(name)
        
            # Get the filename with extension
            file_name = File.basename(file)
            
            # Create the record if necessary
            unless(data = src.data_records.find_by_location(file_name))
              data = data_klass.new
              File.open(file) do |io|
                data.create_from_data(file_name, io)
              end
              src.data_records << data
              src.save!
              data.save!
              created += 1
            end
          else
            not_found << file
          end
          progress.inc
        end
    
        progress.finish
        puts "Done, #{not_found.size} of #{files.size} files had no record associated."
        puts "#{created} new records created."
        puts "\nNot found:" unless(not_found.size == 0)
        not_found.each { |file| puts file}
      end
  
  
      # Get the data class for the type. That does some sanity checks 
      def get_data_class(type)
        data_klass = nil
        begin
          data_klass = TaliaCore::DataTypes.const_get(type)
        rescue Exception => e
          puts("Could get the data type #{type}: #{e}")
          Util.print_options
          exit(1)
        end
    
        # Do the basic check
        unless(data_klass && data_klass.kind_of?(Class) && data_klass.method_defined?('data_directory'))
          puts("Cannot create data class from #{type}")
          exit(1)
        end
    
        # Now check if we are a subclass of the data class
        my_instance = data_klass.new
    
        unless(my_instance.kind_of?(TaliaCore::DataTypes::DataRecord))
          puts("The class #{data_klass} is not a DataRecord, can't create data for it.")
          exit(1)
        end
    
        data_klass
      end
    end
  end
end