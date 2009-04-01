require 'fileutils'

module TaliaCore
  module DataTypes
    
    # Module for the handling of temporary files in data storage objects
    module TempFileHandling
      
      module ClassMethods
        
        # Copies the given file path to a new tempfile, returning the closed tempfile.
        def copy_to_temp_file(file, temp_base_name)
          create_tempfile_path
          returning Tempfile.new(temp_base_name, self.tempfile_path) do |tmp|
            tmp.close
            FileUtils.cp file, tmp.path
          end
        end

        # Writes the given data to a new tempfile, returning the closed tempfile.
        def write_to_temp_file(data, filename)
          create_tempfile_path
          returning Tempfile.new(filename, self.tempfile_path) do |tmp|
            tmp.binmode
            tmp.write data
            tmp.close
          end
        end
        
        def create_tempfile_path
          FileUtils.mkdir_p(tempfile_path) unless File.exists?(tempfile_path)
        end
      
      end
      
      # Gets the latest temp path from the collection of temp paths.  While working with an attachment,
      # multiple Tempfile objects may be created for various processing purposes (resizing, for example).
      # An array of all the tempfile objects is stored so that the Tempfile instance is held on to until
      # it's not needed anymore.  The collection is cleared after saving the attachment.
      def temp_path
        p = temp_paths.first
        p.respond_to?(:path) ? p.path : p.to_s
      end
    
      # Gets an array of the currently used temp paths.  Defaults to a copy of #full_filename.
      def temp_paths
        @temp_paths ||= (new_record? || !File.exist?(full_filename)) ? [] : [copy_to_temp_file(full_filename)]
      end
    
      # Adds a new temp_path to the array.  This should take a string or a Tempfile.  This class makes no 
      # attempt to remove the files, so Tempfiles should be used.  Tempfiles remove themselves when they go out of scope.
      # You can also use string paths for temporary files, such as those used for uploaded files in a web server.
      def temp_path=(value)
        temp_paths.unshift value
        temp_path
      end

      # Gets the data from the latest temp file.  This will read the file into memory.
      def temp_data
        save_attachment? ? File.read(temp_path) : nil
      end
    
      # Writes the given data to a Tempfile and adds it to the collection of temp files.
      def temp_data=(data)
        self.temp_path = write_to_temp_file data unless data.nil?
      end
      
      # Copies the given file to a randomly named Tempfile.
      def copy_to_temp_file(file)
        self.class.copy_to_temp_file file, random_tempfile_filename
      end
    
      # Writes the given file to a randomly named Tempfile.
      def write_to_temp_file(data)
        self.class.write_to_temp_file data, self.location
      end
      
      # Generates a unique filename for a Tempfile. 
      def random_tempfile_filename
        "#{rand Time.now.to_i}#{location || 'attachment'}"
      end
      
    end
  end
end
