module TaliaCore
  module DataTypes
  
    # Contains the helpers to obtain path information for data storage
    module PathHelpers
      
      module ClassMethods
        # Path used to store temporary files.
        def tempfile_path
          @@tempfile_path ||= File.join(TALIA_ROOT, 'tmp', 'data_records')
        end

        # Path used to store data files.
        def data_path
          @@data_path ||= File.join(TALIA_ROOT, 'data')
        end
        
      
            
        # Extract the filename.
        def extract_filename(file_data)
          file_data.original_filename if file_data.respond_to?(:original_filename)
        end
      
      end      
      
      # Return the full file path related to the data directory
      def file_path(relative = false)
        File.join(data_directory(relative), self.id.to_s)
      end
      
      # Gets the path that will be used for serving the image as a static
      # resource. Nil if the prefix isn't set
      def static_path
        prefix = TaliaCore::CONFIG['static_data_prefix']
        return unless(prefix)
        prefix = N::LOCAL + prefix unless(prefix =~ /:\/\//)
        "#{prefix}/#{class_name}/#{("00" + self.id.to_s)[-3..-1]}/#{self.id}"
      end
      
      # Path used to store temporary files.
      # This is a wrapper for the tempfile_path class method.
      def tempfile_path
        self.class.tempfile_path
      end
    
      # Return the data directory for a specific data file
      def data_directory(relative = false)
        class_name = self.class.name.gsub(/(.*::)/, '')
        if relative == false
          File.join(TaliaCore::CONFIG["data_directory_location"], class_name, ("00" + self.id.to_s)[-3..-1])
        else
          File.join(class_name, ("00" + self.id.to_s)[-3..-1])
        end
      end
    
      # Path used to store data files.
      # This is a wrapper for the data_path class method.
      def data_path
        self.class.data_path
      end
      
      # Return the full path of the current attachment.
      def full_filename
        @full_filename ||= self.file_path #File.join(data_path, class_name, location)
      end
      
      # Extract the filename.
      # This is a wrapper for the extract_filename class method.
      def extract_filename(file_data)
        self.class.extract_filename(file_data)
      end
      
    end
  
  end
end
