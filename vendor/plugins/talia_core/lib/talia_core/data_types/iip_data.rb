module TaliaCore
  module DataTypes
    
    # Class to manage IIP Image data type
    class IipData < FileRecord
      
      # Returns the IIP server configured for the application
      def self.iip_server_uri
        TaliaCore::CONFIG['iip_server_uri'] ||= 'http://localhost/fcgi-bin/iipsrv.fcgi'
      end
      
      # Returns the command that is used for converting images
      def vips_command
        TaliaCore::CONFIG['vips_command'] ||= '/opt/local/bin/vips'
      end
      
      # Returns the command that is used for converting thumbnails
      def convert_command
        TaliaCore::CONFIG['convert_command'] ||= '/opt/local/bin/convert'
      end
      
      # Returns the options for the thumbnail
      def thumb_options
        TaliaCore::CONFIG['thumb_options'] ||= { 'width' => '80', 'height' => '120' }
      end
      
      # This is the mime type for the thumbnail - always tiff
      def set_mime_type
        self.mime = 'image/jpeg'
      end
      
      alias :get_thumbnail :all_bytes
     
      # Create from existing thumb and pyramid images
      def create_from_existing(thumb, pyramid, delete_originals = false)
        @file_data_to_write = [thumb, pyramid]
        @delete_original_file = delete_originals
        self.location = ''
      end
      
      # return IIP Server Path
      def iip_server_path
        self.location
      end
      
      def write_file_after_save
        return unless(@file_data_to_write)
        
        # Check if we have the images already given, in this case we prepare
        # them and call the super method
        return super if(direct_write!)
        
        # create name for orginal temp file and destination temp file
        original_file_path, orig_is_temp = prepare_original_file
        will_delete_source = orig_is_temp || @delete_original_file
        destination_thumbnail_file_path = File.join(Dir.tmpdir, "thumbnail_#{random_tempfile_filename}.gif")
        
        begin # Begin the file creation operation
          self.class.benchmark("Making thumb and pyramid for #{self.id}", Logger::INFO) do
          
            create_thumb(original_file_path, destination_thumbnail_file_path)
            create_pyramid(original_file_path)
        
            # Run the super implementation for the thumbnail
            # We will simply tell the system that we have to move the newly create
            # thumb file
            @file_data_to_write = DataPath.new(destination_thumbnail_file_path)
            @delete_original_file = true
          
          end # end benchmarking
          super
          
        ensure
          # delete temp files
          File.delete original_file_path if(File.exists?(original_file_path) && will_delete_source)
        end
      end
      
      
      # Checks if we have file paths given to directly copy thum and image file.
      # Will always return true if such paths were given.
      def direct_write!
        return false unless(@file_data_to_write.kind_of?(Array))
        
        thumb, pyramid = @file_data_to_write
        self.class.benchmark("Direct write for #{self.id}", Logger::INFO) do
          prepare_for_pyramid
        
          copy_or_move(pyramid, get_iip_root_file_path)
        
        end # end benchmark
          
        @file_data_to_write = DataPath.new(thumb)
        
        true
      end

      # This prepares the original file that needs to be converted. This will
      # see if the data to be written is binary data or a file path. If this
      # is binary data, it will create a temporary file on the disk.
      #
      # This returns an array with two elements: The name of the file to 
      # be used (a file system path) and a flag indicating if the file is
      # a temporary file or not.
      def prepare_original_file
        if(@file_data_to_write.is_a?(DataPath))
          [@file_data_to_write, false]
        else
          temp_file = File.join(Dir.tmpdir, "original_#{random_tempfile_filename}")
          # write the original file
          File.open(temp_file, 'w') do |original_file|
            if(@file_data_to_write.respond_to?(:read))
              original_file << @file_data_to_write.read
            else
              original_file << @file_data_to_write
            end
          end
          
          [temp_file, true]
        end
      end
      
      
      # Create the thumbnail by running the configured creation command.
      def create_thumb(source, destination)
        # execute vips command for create thumbnail
        # TODO: to add options, such as size, we can modify this row
        thumbnail_size = "#{thumb_options['width']}x#{thumb_options['height']}"
        thumbnail_command = "#{convert_command} \"#{source}\" -thumbnail \"#{thumbnail_size}>\" -background transparent -gravity center -extent #{thumbnail_size} \"#{destination}\""
        system_result = system(thumbnail_command)

        # check if thumbnails file is created
        raise(IOError, "Command #{thumbnail_command} failed (#{$?}).") unless (File.exists?(destination) || !system_result)
      end
      
      # Prepare for copying or creating the pyramid image
      def prepare_for_pyramid
        # set location
        self.location = get_iip_root_file_path(true)
        
        # create data directory path
        FileUtils.mkdir_p(iip_root_directory)
      end
      
      # Creates the pyramid image for IIP by running the configured system
      # command. This automatically creates the file in the correct location 
      # (IIP root)
      def create_pyramid(source)
        # check if file already exists
        raise(IOError, "File already exists: #{get_iip_root_file_path}") if(File.exists?(get_iip_root_file_path))
       
        prepare_for_pyramid
        
        # execute vips command for create pyramid image
        # TODO: to add options, such as size, we can modify this row
        pyramid_command = "#{vips_command} im_vips2tiff \"#{source}\" \"#{get_iip_root_file_path}\":deflate,tile,pyramid"
        system_result = system(pyramid_command)

        # check if thumbnails file is created
        raise(IOError, "Command #{pyramid_command} failed (#{$?}).") unless (File.exists?(get_iip_root_file_path) || !system_result)
      end
      
      # Return the iip root directory for a specific iip image file
      def iip_root_directory(relative = false)
        if relative == false
          File.join(TaliaCore::CONFIG["iip_root_directory_location"], ("00" + self.id.to_s)[-3..-1])
        else
          File.join(("00" + self.id.to_s)[-3..-1])
        end
      end
      
      # Return the full file path related to the data directory
      def get_iip_root_file_path(relative = false)
        File.join(iip_root_directory(relative), self.id.to_s + '.tif')
      end
      
      private
  
      # Generates a unique filename for a Tempfile. 
      def random_tempfile_filename
        "#{rand 10E16}"
      end
      
    end
    
  end
end
